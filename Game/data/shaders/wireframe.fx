


cbuffer cbNeverChanges
{
    matrix View;
};

cbuffer cbChangeOnResize
{
    matrix Projection;
};

cbuffer cbChangesEveryFrame
{
    matrix Model;
};

struct VS_INPUT
{
    float3 Pos : POSITION;
};

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
};


//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS( VS_INPUT input )
{
    PS_INPUT output = (PS_INPUT)0;
    output.Pos = mul( float4(input.Pos, 1.0f), Model );
    output.Pos = mul( output.Pos, View );
    output.Pos = mul( output.Pos, Projection );
    return output;
}


//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( PS_INPUT input) : SV_Target
{
    return float4(1.0f,1.0f,1.0f,1.0f);
}


//--------------------------------------------------------------------------------------
RasterizerState rs { CullMode = None;  FillMode = WireFrame;};

DepthStencilState ds
{
    DepthFunc = LESS_EQUAL;
    DepthEnable = TRUE;
};

BlendState bs
{
    BlendEnable[0] = False;
};

technique10 Render
{
    pass P0
    {
	    SetDepthStencilState(ds, 0);
		SetRasterizerState(rs);
		SetBlendState(bs, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF);
        SetVertexShader( CompileShader( vs_4_0, VS() ) );
        SetGeometryShader( NULL );
        SetPixelShader( CompileShader( ps_4_0, PS() ) );
    }
}

