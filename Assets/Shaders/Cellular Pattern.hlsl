        #ifndef _CELLULARPATTERN_INC
        #define _OCTAVEGRADIENTNOISE_INC
        
        
        
        float2 random2(float2 p)
        {
            float a = frac(sin(float2(dot(p,float2(127.1,311.7)),dot(p,float2(269.5,183.3))))*43758.5453);
            return float2(a,a); 
        }

        float4 cellular(float3 fragColor, float2 fragCoord){
            float zoom = 10.0;

            float2 uv = fragCoord;
            uv *= zoom;
            float2 i_uv = floor(uv);
            float2 f_uv = frac(uv);

            float3 col = fragColor.rgb;
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

            col += fragColor.rgb;


            return float4(col,1.0);
        }
        void cellular_float(in float3 color, in float2 pos, out float4 n){
            n = cellular(color, pos);
        
        }
#endif