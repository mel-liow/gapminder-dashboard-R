library(dash)

library(ggplot2)
library(plotly)
library(dashBootstrapComponents)
library(dashCoreComponents)
library(dashHtmlComponents)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

gapminder <- readr::read_csv("data/processed/gapminder_processed.csv")


app$layout(
    htmlDiv(
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
                value = "All"
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
                value = "life_expectancy"
            ),
            dccGraph(id = "map")
        )
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
            layout(title = "")

        ggplotly(map_plot)
    }
)

app$run_server(debug = T)