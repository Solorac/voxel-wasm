struct CustomMaterial {
    color: vec4<f32>,
};

@group(1) @binding(0)
var<uniform> material: CustomMaterial;

@fragment
fn fragment(
        @builtin(position) coord: vec4<f32>,
    @location(0) world_position: vec4<f32>,
    @location(1) normal: vec3<f32>,
    @location(2) uv: vec2<f32>
) -> @location(0) vec4<f32> {
    // return material.color * uv.x;

    var color = material.color;

    var width_edge = 0.02;
    var width_corner = 0.06;

    var quad_shading = 1.0;
    var edge_shading = 1.2;
    var corner_shading = 0.8;

    if normal.z > 0.0{
        quad_shading = 0.6;
    }
    else if normal.z < 0.0{
        quad_shading = 0.6;
    }

    if normal.y > 0.0{
        quad_shading = 0.8;
    }

    else if normal.y < 0.0{
    quad_shading = 0.3;
    }

    if normal.x > 0.0{
        quad_shading = 0.4;
    }
    else if normal.x < 0.0{
        quad_shading = 0.4;
    }

    color = vec4<f32>(color.xyz * quad_shading, 1.0);


    //Edge shading
    if uv.x > 1.0 - width_edge || uv.x < 0.0 + width_edge{
        color = vec4<f32>(color.xyz * edge_shading, 1.0);
    }

    if uv.y > 1.0 - width_edge || uv.y < 0.0 + width_edge{
        color = vec4<f32>(color.xyz * edge_shading, 1.0);
    }


    //Corner shading
    if uv.x > 1.0 - width_corner && uv.y < 0.0 + width_corner{
        color = vec4<f32>(color.xyz * corner_shading, 1.0);
    }
    if uv.x > 1.0 - width_corner && uv.y > 1.0 - width_corner{
        color = vec4<f32>(color.xyz * corner_shading, 1.0);
    }

    if uv.y > 1.0 - width_corner && uv.x < 0.0 + width_corner{
        color = vec4<f32>(color.xyz * corner_shading, 1.0);
    }

    if uv.y < 0.0 + width_corner && uv.x < 0.0 + width_corner{
        color = vec4<f32>(color.xyz * corner_shading, 1.0);
    }

    return color;



}