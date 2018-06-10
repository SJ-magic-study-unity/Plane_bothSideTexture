/************************************************************
description : 【Unityシェーダ】テクスチャの両面を描画する方法
	参考URL
		http://nn-hokuson.hatenablog.com/entry/2017/03/03/202309

	contents
		Planeオブジェクトにテクスチャを貼り付けると、両面が描画されるのではなく裏面は透明になってしまいます。
		
		片面だけが描画されてしまうのは、カリングと呼ばれる「見えないところは描画しない設定」が原因です。
		カリングをオフにして両面を表示するためには、シェーダを書く必要があります（インスペクタから設定したいところですが・・・）
		
		ここでは、プロジェクトビューで「Create」→「Shader」→「Unlit Shader」を選択してください。
		作成したデフォルトのUnlitシェーダに、カリングをオフにして両面表示する設定を書き加えます。
		
		本shaderでは、デフォルトで生成されるUnlitLシェーダに3行追加しています。
			「LOD100」と書かれた行の下に「Cull off」の一行を追加しています。
		カリングを切るだけであれば追加するのはこの一行でOKです。これによりテクスチャの両面表示ができるようになります。
		
		今回は、テクスチャの透明部分にも対応できるようにするため、合わせてTransparentの設定をしています。
			Tags { "RenderType"="Transparent" "Queue"="Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha 
			
		このシェーダを両面を描画したいオブジェクトにアタッチして実行してみてください。
		設定する前は片面しか描画されていませんでしたが、カリングをOFFにしたことで両面ともテクスチャが描画されるようになりました。
************************************************************/
Shader "Unlit/culloff"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 100
		Cull off
		Blend SrcAlpha OneMinusSrcAlpha 


		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
