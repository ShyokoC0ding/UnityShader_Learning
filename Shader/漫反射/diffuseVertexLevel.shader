/**
    简单漫反射模型-逐顶点法
*/
Shader "Unity Shaders Book/Chapter 6/Diffuse Vertex-Level"
{
	Properties
	{
		// 声明一个 Color 类型的属性, 表示材质的漫反射颜色
		_Diffuse("Diffuse",Color) = (1,1,1,1)
	}
	SubShader
	{
		Pass //渲染通道
		{
			Tags {"LightMode"="ForwardBase"} // Forward 渲染路径
			
			CGPROGRAM  //CG代码片段开始
			#pragma vertex vert  // 指示 vert函数包含了顶点着色器代码
			#pragma fragment frag  //指示 frag函数包含了片元着色器代码
			#include "Lighting.cginc" //需要使用 Unity 内置变量

			fixed4 _Diffuse; // 为了使用 Properties 中声明的属性，定义和该属性类型匹配的变量

			//定义顶点着色器输入结构体
			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			//定义片元着色器输入结构体
			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 color : COLOR; // 教材使用了 COLOR 变量
			};

			//编写顶点着色器 ; 逐顶点的漫反射光照模型, 漫反射部分的计算都在顶点着色器中进行
			v2f vert (a2v v)
			{
				v2f o;
				// 把模型空间的坐标转换到投影空间
				o.pos = UnityObjectToClipPos(v.vertex);
				//获取环境光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				// 把模型空间的法线转换到世界空间
				fixed3 worldNormal = normalize(mul(v.normal,(float3x3)unity_WorldToObject));
				// 获取世界空间的光源方向
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

				//计算漫反射光照
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb *
									saturate(dot(worldNormal,worldLight));
				//光照结果
				o.color = ambient + diffuse;
				
				return o;
			}

			//编写片元着色器, 只负责输出顶点颜色
			fixed4 frag(v2f i) : SV_Target
			{
				return fixed4(i.color,1.0);
			}
			ENDCG //CG代码片段结束
		}
	}
	Fallback "Diffuse" //回调Shader设置为内置的Diffuse
}
