

/** 
    一个 Unity Shader的基础框架
      
*/

Shader "unity shaders book/ch5/simple shader" // 通过 Shader语义 定义名字
{
    Properties
    {
        //声明一个 Color 类型的属性
        _Color("Color Tint",Color) = (11.0,1.0,1.0,1.0)
    }
    
    SubShader
    {
        Pass
        {
            CGPROGRAM /*CG 代码片段 开始 */
            
            #pragma vertex vert  // 指定 vert函数 包含了顶点着色器的代码
            #pragma fragment frag // 指定 frag函数 包含了片元着色器的代码

            fixed4 _Color;
            
            struct a2_v
            {
                float4 vertex : POSITION; //用顶点坐标填充 vertex
                float3 normal : NORMAL; //用法线方向填充 normal
                float4 texcoord : TEXCOORD0;  //用模型的第一套纹理坐标填充 texcoord
            };

            struct v2_f
            {   
                float4 pos: SV_POSITION;
                fixed3 color: COLOR0;
            };
            
/*            float4 origin(float4 v : POSITION) : SV_POSITION {
                return UnityObjectToClipPos (v); // 把顶点坐标 从 模型空间 转换到 裁剪空间 中
            }*/
            /*  vert函数 返回一个 float4 类型的变量
             *  输入 v 包含顶点的位置
             *  POSITION 和 SV_POSITION 是 Cg/HLSL中的 语义 (semantics)
             *  POSITION 告诉 Unity , 把模型的顶点坐标填充到输入参数v中
             *  SV_POSITION 告诉 Unity, 顶点着色器的输出是裁剪空间中的顶点坐标
             */

            // float4 vert(a2_v v): SV_POSITION {
            //     return UnityObjectToClipPos (v.vertex);
            // }
            
            v2_f vert(a2_v v){
                v2_f o;
                o.pos = UnityObjectToClipPos(v.vertex); 
                o.color = v.normal*0.5 + fixed3(0.5,0.5,0.5);
                /*  法线方向 范围在 [-1.0, 1.0] 之间
                 *  将其映射到 [0.0,1.0] 后传递给片元着色器
                 */
                return o;
            }
            

            
            // fixed4 frag() :SV_Target {
            //     return fixed4(1.0,1.0,1.0,1.0);
            // }
            /*  返回一个fixed4类型的变量
             *  无输入
             *  SV_Target 是 语义, 告诉渲染器, 把用户的输出颜色存储到渲染目标中,
             *这里将输出到默认的帧缓存
             *  片元着色器的颜色分量范围在 [0,1] 之间, (0,0,0) 是黑色， (1,1,1) 是白色
             */

            // fixed4 frag(v2_f i): SV_Target {
            //     fixed3 c = i.color;
            //     //将插值后的 i.color 显示到屏幕上
            //     c *=_Color.rgb;
            //     return fixed4(i.color,1.0);
            // }

            fixed4 frag(v2_f i): SV_Target{
                fixed3 c = i.color;
                //将插值后的 i.color 显示到屏幕上
                c *=_Color.rgb;
                return fixed4(i.color,1.0);
            }
            
            ENDCG /* CG 代码片段 结尾 */
            
        }
        
    }
}

