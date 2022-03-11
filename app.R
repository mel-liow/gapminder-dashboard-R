library(dash)

library(ggplot2)
library(plotly)
library(dashBootstrapComponents)
library(dashCoreComponents)
library(dashHtmlComponents)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

gapminder <- readr::read_csv("data/processed/gapminder_processed.csv")

labels <- list(
    "life_expectancy" = "Life Expectancy",
    "education_ratio" = "Education Ratio",
    "pop_density" = "Population Density",
    "child_mortality" = "Child Mortality",
    "children_per_woman" = "Children per Woman"
)


app$layout(
    dbcContainer(
        list(
            htmlH1("Gapminder Dashboard"),
            dccDropdown(
                id = "region",
                options = list(
                    list(label = "All", value = "All"),
                    list(label = "Africa", value = "Africa"),
                    list(label = "Asia", value = "Asia"),
                    list(label = "Americas", value = "Americas"),
                    list(label = "Europe", value = "Europe"),
                    list(label = "Oceania", value = "Oceania")
                ),
                value = "All",
                style = list("width" = "350px", "margin-bottom" = "10px")
            ),
            dccDropdown(
                id = "stat",
                options = list(
                    list(label = "Income", value = "income"),
                    list(label = "Life Expectancy", value = "life_expectancy"),
                    list(label = "Children per Woman", value = "children_per_woman"),
                    list(label = "Child Mortality", value = "child_mortality"),
                    list(label = "Population Density", value = "pop_density"),
                    list(label = "CO2 Per Capita", value = "co2_per_capita"),
                    list(label = "Years in school (Men)", value = "years_in_school_men"),
                    list(label = "Years in school (Women)", value = "years_in_school_women")
                ),
                value = "life_expectancy",
                style = list("width" = "350px")
            ),
            dbcContainer(
                list(
                    dccGraph(id = "map")
                )
            )
        ),
        style = list("padding" = "20px")
    )
)


app$callback(
    output("map", "figure"),
    list(
        input("region", "value"),
        input("stat", "value")
    ),
    function(region, stat) {
        region_value <- region

        data <- gapminder

        if (region_value != "All") {
            data <- data |>
                filter(region == region_value)
        }


        map_plot <- plot_ly(data,
            type = "choropleth",
            locations = ~code,
            z = data[[stat]],
            text = ~country,
            color = data[[stat]],
            colors = "Reds"
        ) |>
            layout(title = paste0(labels[[stat]], " for ", region_value))

        ggplotly(map_plot)
    }
)

app$run_server(host = "0.0.0.0")