module graph_results
using Gadfly, DataFrames

export calculate_minimum_profit

function graph_cities(cities::DataFrame)
    p = plot(cities, x=:x_axis, y=:y_axis, Geom.point);
    img = SVG(ENV["PLOT"], 14cm, 8cm)
    draw(img, p)
end

end
