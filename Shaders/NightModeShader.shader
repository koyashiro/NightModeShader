Shader "koyashiro/NightModeShader"
{
    Properties
    {
        _Darkness ("Darkness", Range(0.8, 1)) = 0.95
        _Radius ("Radius", Float) = 2
    }
    SubShader
    {
        Tags{
          "RenderType"="Transparent"
          "Queue"="Transparent+10000"
        }
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            cull back

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD1;
            };

            float _Darkness;
            float _Radius;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                bool isMirror = unity_CameraProjection[2][0] != 0.f || unity_CameraProjection[2][1] != 0.f;
                if (isMirror)
                {
                    discard;
                }

#if defined(USING_STEREO_MATRICES)
                float3 cameraPos = (unity_StereoWorldSpaceCameraPos[0] + unity_StereoWorldSpaceCameraPos[1]) / 2;
#else
                float3 cameraPos = _WorldSpaceCameraPos;
#endif
                float dist = distance(i.worldPos, cameraPos);
                if (dist <= _Radius) {
                    discard;
                }

                fixed4 col = fixed4(0, 0, 0, _Darkness);
                return col;
            }
            ENDCG
        }

        Pass
        {
            cull front
            ZTest Always

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
                float3 worldPos : TEXCOORD1;
            };

            float _Darkness;
            float _Radius;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                bool isMirror = unity_CameraProjection[2][0] != 0.f || unity_CameraProjection[2][1] != 0.f;
                if (isMirror)
                {
                    discard;
                }

#if defined(USING_STEREO_MATRICES)
                float3 cameraPos = (unity_StereoWorldSpaceCameraPos[0] + unity_StereoWorldSpaceCameraPos[1]) / 2;
#else
                float3 cameraPos = _WorldSpaceCameraPos;
#endif
                float dist = distance(i.worldPos, cameraPos);
                if (dist > _Radius) {
                    discard;
                }

                fixed4 col = fixed4(0, 0, 0, _Darkness);
                return col;
            }
            ENDCG
        }
    }
}
