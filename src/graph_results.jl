module graph_results
import Cairo, Fontconfig
using Gadfly, DataFrames, Cairo, Fontconfig

function graph_cities(cities::Matrix, I::Array)
    df_cities = DataFrame(x_axis = cities[:, 2], y_axis = cities[:, 3], label = string.(cities[:, 1]))

    p = plot(
        df_cities,
        x = "x_axis",
        y = "y_axis",
        Geom.point,
        Guide.xlabel("X"),
        Guide.ylabel("Y"),
        layer(
            x = df_cities.x_axis[I],
            y = df_cities.y_axis[I],
            xend = df_cities.x_axis[I[2:end]],
            yend = df_cities.y_axis[I[2:end]],
            label = df_cities.label[I],  # Add label aesthetic
            Geom.segment,
            Geom.point,
            Geom.label,
            style(default_color=color("black"))
        )
    )
    
    # Save the plot to a PNG file
    draw(PNG(ENV["PLOT"], 50cm, 25cm), p)
end

end
