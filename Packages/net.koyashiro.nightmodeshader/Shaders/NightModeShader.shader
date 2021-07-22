Shader "koyashiro/NightModeShader"
{
    Properties
    {
        _Darkness ("Darkness", Range(0.8, 1)) = 0.9
    }
    SubShader
    {
        Tags{
          "RenderType"="Transparent"
          "Queue"="Transparent+10000"
        }
        cull front
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100
        ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            float _Darkness;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                bool isMirror = unity_CameraProjection[2][0] != 0.f || unity_CameraProjection[2][1] != 0.f;
                if (isMirror)
                {
                    discard;
                }

                fixed4 col = fixed4(0, 0, 0, _Darkness);
                return col;
            }
            ENDCG
        }
    }
}
