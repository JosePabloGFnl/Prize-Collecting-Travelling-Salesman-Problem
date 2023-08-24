module graph_results
using Gadfly, DataFrames, Cairo, Fontconfig

function graph_cities(cities::Matrix, I::Array)
    df_cities = DataFrame(x_axis = cities[:, 2], y_axis = cities[:, 3], label = string.(cities[:, 1]))
    
    p = plot(df_cities, x=:x_axis, y=:y_axis, Geom.point)
    
    img = PNG(ENV["PLOT"], 50cm, 25cm)
    draw(img, p)
end

end
