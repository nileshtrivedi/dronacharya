require 'json'

def route(starting_latlng)
    viapoints = [
        [starting_latlng[0] - 0.033, starting_latlng[1] + 0.05],
        [starting_latlng[0] - 0.067, starting_latlng[1] + 0.05],
        [starting_latlng[0] - 0.1, starting_latlng[1] + 0.1]
    ]

    res = []
    prev = starting_latlng
    num = 100
    viapoints.each_with_index do |v,i|
        dx = v[0] - prev[0]
        dy = v[1] - prev[1]
        (0..num).to_a.each do |k|
            res.push([prev[0] + dx * k / num, prev[1] + dy * k / num])
        end
        prev = v
    end
    return res
end

def trip(route, should_deviate = false)
    return route unless should_deviate
    rl = route.length
    t = route.each_with_index.map do |p, i|
        (i < rl / 2) ? p : [p[0] + 0.03*((i - rl/2).to_f/rl), p[1] + 0.03*((i - rl/2).to_f/rl)]
    end
    return t
end

def fence_polygons(route, size)
    pi = Math::PI
    route.map do |p|
        [[
            [p[0] + size * Math.cos(pi*0/3), p[1] + size * Math.sin(pi*0/3)],
            [p[0] + size * Math.cos(pi*1/3), p[1] + size * Math.sin(pi*1/3)],
            [p[0] + size * Math.cos(pi*2/3), p[1] + size * Math.sin(pi*2/3)],
            [p[0] + size * Math.cos(pi*3/3), p[1] + size * Math.sin(pi*3/3)],
            [p[0] + size * Math.cos(pi*4/3), p[1] + size * Math.sin(pi*4/3)],
            [p[0] + size * Math.cos(pi*5/3), p[1] + size * Math.sin(pi*5/3)],
            [p[0] + size * Math.cos(pi*0/3), p[1] + size * Math.sin(pi*0/3)]
        ]]
    end
end

def fence_polygons_json(fp)
    {
        type: "Feature",
        geometry: {
            type: "MultiPolygon",
            coordinates: fp
        }
    }.to_json
end

def trip_json(t)
    {
        "type": "FeatureCollection",
        "features": [
            {
                "type": "Feature",
                "geometry": {
                    "type": "LineString",
                    "coordinates": t
                }
            }
        ]
    }.to_json
end

start = [77.682, 12.96]
r = route(start)
t = trip(r, true)
File.open("fenceblr.geojson", "w") do |f|
    f.write(fence_polygons_json(fence_polygons(r,0.004)))
end

File.open("tripblr.geojson", "w") do |f|
    f.write(trip_json(t))
end