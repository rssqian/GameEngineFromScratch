#version 420

struct cube_vert_output
{
    vec4 pos;
    vec3 uvw;
};

struct Light
{
    float lightIntensity;
    int lightType;
    int lightCastShadow;
    int lightShadowMapIndex;
    int lightAngleAttenCurveType;
    int lightDistAttenCurveType;
    vec2 lightSize;
    ivec4 lightGuid;
    vec4 lightPosition;
    vec4 lightColor;
    vec4 lightDirection;
    vec4 lightDistAttenCurveParams[2];
    vec4 lightAngleAttenCurveParams[2];
    mat4 lightVP;
    vec4 padding[2];
};

layout(binding = 13, std140) uniform DebugConstants
{
    float layer_index;
    float mip_level;
    float line_width;
    float padding0;
    vec4 front_color;
    vec4 back_color;
} _230;

uniform sampler2DArray SPIRV_Cross_Combinedcubemapsamp0;

layout(location = 0) in vec3 _entryPointOutput_uvw;
layout(location = 0) out vec4 _entryPointOutput;

vec3 convert_xyz_to_cube_uv(vec3 d)
{
    vec3 d_abs = abs(d);
    bvec3 isPositive;
    isPositive.x = int(d.x > 0.0) != int(0u);
    isPositive.y = int(d.y > 0.0) != int(0u);
    isPositive.z = int(d.z > 0.0) != int(0u);
    float maxAxis;
    float uc;
    float vc;
    int index;
    if ((isPositive.x && (d_abs.x >= d_abs.y)) && (d_abs.x >= d_abs.z))
    {
        maxAxis = d_abs.x;
        uc = -d.z;
        vc = d.y;
        index = 0;
    }
    if (((!isPositive.x) && (d_abs.x >= d_abs.y)) && (d_abs.x >= d_abs.z))
    {
        maxAxis = d_abs.x;
        uc = d.z;
        vc = d.y;
        index = 1;
    }
    if ((isPositive.y && (d_abs.y >= d_abs.x)) && (d_abs.y >= d_abs.z))
    {
        maxAxis = d_abs.y;
        uc = d.x;
        vc = -d.z;
        index = 3;
    }
    if (((!isPositive.y) && (d_abs.y >= d_abs.x)) && (d_abs.y >= d_abs.z))
    {
        maxAxis = d_abs.y;
        uc = d.x;
        vc = d.z;
        index = 2;
    }
    if ((isPositive.z && (d_abs.z >= d_abs.x)) && (d_abs.z >= d_abs.y))
    {
        maxAxis = d_abs.z;
        uc = d.x;
        vc = d.y;
        index = 4;
    }
    if (((!isPositive.z) && (d_abs.z >= d_abs.x)) && (d_abs.z >= d_abs.y))
    {
        maxAxis = d_abs.z;
        uc = -d.x;
        vc = d.y;
        index = 5;
    }
    vec3 o;
    o.x = 0.5 * ((uc / maxAxis) + 1.0);
    o.y = 0.5 * ((vc / maxAxis) + 1.0);
    o.z = float(index);
    return o;
}

vec4 _cubemaparray_frag_main(cube_vert_output _entryPointOutput_1)
{
    vec3 param = _entryPointOutput_1.uvw;
    vec3 uvw = convert_xyz_to_cube_uv(param);
    uvw.z += (_230.layer_index * 6.0);
    return textureLod(SPIRV_Cross_Combinedcubemapsamp0, uvw, _230.mip_level);
}

void main()
{
    cube_vert_output _entryPointOutput_1;
    _entryPointOutput_1.pos = gl_FragCoord;
    _entryPointOutput_1.uvw = _entryPointOutput_uvw;
    cube_vert_output param = _entryPointOutput_1;
    _entryPointOutput = _cubemaparray_frag_main(param);
}

