#import bevy_pbr::mesh_types
#import bevy_pbr::mesh_view_bindings

@group(1) @binding(0)
var<uniform> mesh: Mesh;

// NOTE: Bindings must come before functions that use them!
#import bevy_pbr::mesh_functions

struct Vertex {
    @location(0) position: vec3<f32>,
    @location(1) normal: vec3<f32>,
    @location(2) uv: vec2<f32>,
    @location(3) i_pos_scale: vec4<f32>,
    @location(4) i_color: vec4<f32>,
};

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,

    @location(1) normal: vec3<f32>,
    @location(2) uv: vec2<f32>,
    @location(4) color: vec4<f32>,
};

@vertex
fn vertex(vertex: Vertex) -> VertexOutput {
    let position = vertex.position * vertex.i_pos_scale.w + vertex.i_pos_scale.xyz;
    var out: VertexOutput;

    out.color = vertex.i_color;
    out.normal = vertex.normal;
    out.uv = vertex.uv;
    out.clip_position = mesh_position_local_to_clip(mesh.model, vec4<f32>(position, 1.0));

    return out;
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    var color = in.color;

    var width_edge = 0.02;
    var width_corner = 0.06;

    var quad_shading = 1.0;
    var edge_shading = 1.2;
    var corner_shading = 0.8;

    if in.normal.z > 0.0{
        quad_shading = 0.6;
    }
    else if in.normal.z < 0.0{
        quad_shading = 0.6;
    }

    if in.normal.y > 0.0{
        quad_shading = 0.8;
    }

    else if in.normal.y < 0.0{
    quad_shading = 0.3;
    }

    if in.normal.x > 0.0{
        quad_shading = 0.4;
    }
    else if in.normal.x < 0.0{
        quad_shading = 0.4;
    }

    color = vec4<f32>(color.xyz * quad_shading, 1.0);


    //Edge shading
    if in.uv.x > 1.0 - width_edge || in.uv.x < 0.0 + width_edge{
        color = vec4<f32>(color.xyz * edge_shading, 1.0);
    }

    if in.uv.y > 1.0 - width_edge || in.uv.y < 0.0 + width_edge{
        color = vec4<f32>(color.xyz * edge_shading, 1.0);
    }


    //Corner shading
    if in.uv.x > 1.0 - width_corner && in.uv.y < 0.0 + width_corner{
        color = vec4<f32>(color.xyz * corner_shading, 1.0);
    }
    if in.uv.x > 1.0 - width_corner && in.uv.y > 1.0 - width_corner{
        color = vec4<f32>(color.xyz * corner_shading, 1.0);
    }

    if in.uv.y > 1.0 - width_corner && in.uv.x < 0.0 + width_corner{
        color = vec4<f32>(color.xyz * corner_shading, 1.0);
    }

    if in.uv.y < 0.0 + width_corner && in.uv.x < 0.0 + width_corner{
        color = vec4<f32>(color.xyz * corner_shading, 1.0);
    }

    return color;
}
