/**
    高光反射--逐像素法
*/
Shader "Specular Pixel-Level"
{
    Properties
    {
        _Diffuse("Diffuse",Color) = (1,1,1,1)
        _Specular("Specular",Color) = (1,1,1,1)
        _Gloss("Gloss",Range(8.0,256)) = 20
    }
    
    SubShader
    {
        Pass
        {
            Tags {"LightMode"= "ForwardBase"}
            
            CGPROGRAM

            #include "Lighting.cginc"
            #pragma vertex vert
            #pragma fragment frag
            
            float4 _Diffuse;
            float4 _Specular;
            float _Gloss;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = mul(v.normal,(float3x3)unity_WorldToObject);
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb *
                                saturate(dot(worldNormal,worldLightDir));
                fixed3 reflectDir = normalize(reflect(-worldLightDir,worldNormal));
                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
                fixed3 specular = _LightColor0.rgb * _Specular.rgb *
                                pow(saturate(dot(reflectDir,viewDir)),_Gloss);
                fixed3 color = ambient + diffuse + specular;
                
                return fixed4 (color,1.0);
            }
            ENDCG
        }
    }
    Fallback "Specular"
}