Shader "Custom/Cellular Pattern"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex; 
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        float2 random2(float2 p)
        {
            float a = frac(sin(float2(dot(p,float2(127.1,311.7)),dot(p,float2(269.5,183.3))))*43758.5453);
            return float2(a,a); 
        }

        float4 cellular(float4 fragColor, float2 fragCoord){
            float zoom = 10.0;

            float2 uv = fragCoord;
            uv *= zoom;
            float2 i_uv = floor(uv);
            float2 f_uv = frac(uv);

            float3 col = _Color.rgb;
            //col = float3(Min(0.1, 0.5));
            float m_dist = 1.0f;
            for(int y = -1; y<=1;y++){
                for(int x = -1; x<=1;x++){
                    float2 neighbor = float2(float(x), float(y));
                    float2 pt = random2(i_uv + neighbor);
            
                    pt = float2(0.5, 0.5) + 0.5 *(sin(_Time.b + 6.075 * pt)); 

                    float2 diff = neighbor + pt - f_uv;
                    float dist = length(diff);
                    m_dist = min(m_dist, dist);
                }
            }
            col = float3(m_dist, m_dist, m_dist); 
            col -= smoothstep(0., .1, abs(sin(27.0*m_dist)) - .8)*.5;
            //col -= clamp(sin(64.*m_dist), 0., 1.)*.5;
            
            // col.b += 0.65;
            // col.g += 0.35;

            col += _Color.rgb;

            fragColor = float4(col,1.0);

            return fragColor;
        }

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float4 col = (cellular(_Color, IN.uv_MainTex));
            // Albedo comes from a texture tinted by color
            //fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = col.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
