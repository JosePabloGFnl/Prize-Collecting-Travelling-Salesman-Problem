module graph_results
using DotEnv, Gadfly, DataFrames, DelimitedFiles

DotEnv.load()

function graph_cities(cities_file::AbstractString)
    cities = readdlm(cities_file, '\t', Int64)
    p = plot(cities, x=:x_axis, y=:y_axis, Geom.point)

    # Extract the x and y coordinates of the points specified by labels in I
    selected_points = filter(row -> row[:label] in I, cities)
    x_selected = selected_points.x_axis
    y_selected = selected_points.y_axis

    # Create line segments between selected points
    line_segments = [(x_selected[i], y_selected[i], x_selected[i+1], y_selected[i+1]) for i in 1:length(x_selected)-1]

    # Add line segments to the plot
    p = layer(p, Geom.path, x=line_segments, y=line_segments, group=1)
    
    img = SVG(ENV["PLOT"], 14cm, 8cm)
    draw(img, p)

end

end
