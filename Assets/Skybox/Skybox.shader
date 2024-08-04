Shader "Joseph&Minions/StylizedSkybox"
{
    Properties
    {
        [Header(Stars Settings)]
        _Stars("Stars Texture", 2D) = "black" {}
        _StarsCutoff("Stars Cutoff",  Range(0, 1)) = 0.08
        _StarsSpeed("Stars Move Speed",  Range(0, 1)) = 0.3 
        _StarsSkyColor("Stars Sky Color", Color) = (0.0,0.2,0.1,1)
 
         [Header(Horizon Settings)]
        _OffsetHorizon("Horizon Offset",  Range(-1, 1)) = 0
        _HorizonIntensity("Horizon Intensity",  Range(0, 10)) = 3.3
        _SunSet("Sunset/Rise Color", Color) = (1,0.8,1,1)
        _HorizonColorDay("Day Horizon Color", Color) = (0,0.8,1,1)
        _HorizonColorNight("Night Horizon Color", Color) = (0,0.8,1,1)
 
         [Header(Sun Settings)]
         _SunColor("Sun Color", Color) = (1,1,1,1)
        _SunRadius("Sun Radius",  Range(0, 2)) = 0.1
        _SunriseStart("Sunrise Start Angle", Range(-1, 0)) = -0.2
        _SunriseEnd("Sunrise End Angle", Range(-1, 1)) = -0.1
        _SunsetStart("Sunset Start Angle", Range(0, 1)) = 0.1
        _SunsetEnd("Sunset End Angle", Range(0, 1)) = 0.2
        _SunriseSunsetIntensity("Sunrise/Sunset Intensity", Range(0, 1)) = 0.5
 
        [Header(Moon Settings)]
        _MoonColor("Moon Color", Color) = (1,1,1,1)
        _MoonRadius("Moon Radius",  Range(0, 2)) = 0.15
        _MoonOffset("Moon Crescent",  Range(-1, 1)) = -0.1
 
        [Header(Day Sky Settings)]
        _DayTopColor("Day Sky Color Top", Color) = (0.4,1,1,1)
        _DayBottomColor("Day Sky Color Bottom", Color) = (0,0.8,1,1)
 
        [Header(Main Cloud Settings)]
        _BaseNoise("Base Noise", 2D) = "black" {}
        _Distort("Distort", 2D) = "black" {}
        _SecNoise("Secondary Noise", 2D) = "black" {}
        _BaseNoiseScale("Base Noise Scale",  Range(0, 1)) = 0.2
        _DistortScale("Distort Noise Scale",  Range(0, 1)) = 0.06
        _SecNoiseScale("Secondary Noise Scale",  Range(0, 1)) = 0.05
        _Distortion("Extra Distortion",  Range(0, 1)) = 0.1
        _Speed("Movement Speed",  Range(0, 10)) = 1.4
        _CloudCutoff("Cloud Cutoff",  Range(0, 1)) = 0.3
        _Fuzziness("Cloud Fuzziness",  Range(0, 1)) = 0.04
        _FuzzinessUnder("Cloud Fuzziness Under",  Range(0, 1)) = 0.01
        [Toggle(FUZZY)] _FUZZY("Extra Fuzzy clouds", Float) = 1
 
        [Header(Day Clouds Settings)]
        _CloudColorDayEdge("Clouds Edge Day", Color) = (1,1,1,1)
        _CloudColorDayMain("Clouds Main Day", Color) = (0.8,0.9,0.8,1)
        _CloudColorDayUnder("Clouds Under Day", Color) = (0.6,0.7,0.6,1)
        _Brightness("Cloud Brightness",  Range(1, 10)) = 2.5
        [Header(Night Sky Settings)]
        _NightTopColor("Night Sky Color Top", Color) = (0,0,0,1)
        _NightBottomColor("Night Sky Color Bottom", Color) = (0,0,0.2,1)
 
        [Header(Night Clouds Settings)]
        _CloudColorNightEdge("Clouds Edge Night", Color) = (0,1,1,1)
        _CloudColorNightMain("Clouds Main Night", Color) = (0,0.2,0.8,1)
        _CloudColorNightUnder("Clouds Under Night", Color) = (0,0.2,0.6,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Background" "RenderPipeline"="UniversalPipeline" }
        //LOD 100

        Pass
        {
            Name "Skybox"

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature FUZZY
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct Attributes
            {
                float3 positionOS : POSITION;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float3 positionWS : TEXCOORD0;
            };

            CBUFFER_START(UnityPerMaterial)
                float _SunRadius, _MoonRadius, _MoonOffset, _OffsetHorizon;
                float4 _SunColor, _MoonColor;
                float4 _DayTopColor, _DayBottomColor, _NightBottomColor, _NightTopColor;
                float4 _HorizonColorDay, _HorizonColorNight, _SunSet;
                float _StarsCutoff, _StarsSpeed, _HorizonIntensity;
                float _BaseNoiseScale, _DistortScale, _SecNoiseScale, _Distortion;
                float _Speed, _CloudCutoff, _Fuzziness, _FuzzinessUnder, _Brightness;
                float4 _CloudColorDayEdge, _CloudColorDayMain, _CloudColorDayUnder;
                float4 _CloudColorNightEdge, _CloudColorNightMain, _CloudColorNightUnder, _StarsSkyColor;
                float _SunriseStart, _SunriseEnd, _SunsetStart, _SunsetEnd, _SunriseSunsetIntensity;
            CBUFFER_END

            TEXTURE2D(_Stars);
            SAMPLER(sampler_Stars);
            TEXTURE2D(_BaseNoise);
            SAMPLER(sampler_BaseNoise);
            TEXTURE2D(_Distort);
            SAMPLER(sampler_Distort);
            TEXTURE2D(_SecNoise);
            SAMPLER(sampler_SecNoise);

            Varyings vert (Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.positionWS = TransformObjectToWorld(IN.positionOS.xyz);
                return OUT;
            }

            half4 frag (Varyings IN) : SV_TARGET
            {
                float3 worldDir = normalize(IN.positionWS);

                // Get main light direction
                Light mainLight = GetMainLight();
                float3 lightDir = mainLight.direction;

                //float horizon = abs((worldDir.y * _HorizonIntensity) - _OffsetHorizon);

                float horizonFactor = saturate((worldDir.y - _OffsetHorizon) / _HorizonIntensity);
                float horizon = lerp(1, abs(worldDir.y * _HorizonIntensity), 1 - _OffsetHorizon);

                // Sky UV
                float2 skyUV = worldDir.xz / (worldDir.y + 1.0);

                // Clouds
                float2 flatSkyUV = IN.positionWS.xz / (abs(IN.positionWS.y) + 1.0);
                float baseNoise = SAMPLE_TEXTURE2D(_BaseNoise, sampler_BaseNoise, (flatSkyUV - _Time.x) * _BaseNoiseScale).x;
                float noise1 = SAMPLE_TEXTURE2D(_Distort, sampler_Distort, ((flatSkyUV + baseNoise) - (_Time.x * _Speed)) * _DistortScale).x;
                float noise2 = SAMPLE_TEXTURE2D(_SecNoise, sampler_SecNoise, ((flatSkyUV + (noise1 * _Distortion)) - (_Time.x * (_Speed * 0.5))) * _SecNoiseScale).x;
                float finalNoise = saturate(noise1 * noise2) * 3 * saturate(worldDir.y);

                #if FUZZY
                float clouds = saturate(smoothstep(_CloudCutoff * baseNoise, _CloudCutoff * baseNoise + _Fuzziness, finalNoise));
                float cloudsunder = saturate(smoothstep(_CloudCutoff * baseNoise, _CloudCutoff * baseNoise + _FuzzinessUnder + _Fuzziness, noise2) * clouds);
                #else
                float clouds = saturate(smoothstep(_CloudCutoff, _CloudCutoff + _Fuzziness, finalNoise));
                float cloudsunder = saturate(smoothstep(_CloudCutoff, _CloudCutoff + _Fuzziness + _FuzzinessUnder, noise2) * clouds);
                #endif

                float3 cloudsColored = lerp(_CloudColorDayEdge.rgb, lerp(_CloudColorDayUnder.rgb, _CloudColorDayMain.rgb, cloudsunder), clouds) * clouds;
                float3 cloudsColoredNight = lerp(_CloudColorNightEdge.rgb, lerp(_CloudColorNightUnder.rgb, _CloudColorNightMain.rgb, cloudsunder), clouds) * clouds;
                cloudsColoredNight *= horizon;

                float dayAmount = saturate(lightDir.y);
                cloudsColored = lerp(cloudsColoredNight, cloudsColored, dayAmount);
                cloudsColored += (_Brightness * cloudsColored * horizon);

                float cloudsNegative = (1 - clouds) * horizon;

                // Sun
                float sun = distance(worldDir.xyz, lightDir);
                float sunDisc = 1 - (sun / _SunRadius);
                sunDisc = saturate(sunDisc * 50);

                // Moon
                float moon = distance(worldDir.xyz, -lightDir);
                float crescentMoon = distance(float3(worldDir.x + _MoonOffset, worldDir.yz), -lightDir);
                float crescentMoonDisc = 1 - (crescentMoon / _MoonRadius);
                crescentMoonDisc = saturate(crescentMoonDisc * 50);
                float moonDisc = 1 - (moon / _MoonRadius);
                moonDisc = saturate(moonDisc * 50);
                moonDisc = saturate(moonDisc - crescentMoonDisc);

                float3 sunAndMoon = (sunDisc * _SunColor.rgb) + (moonDisc * _MoonColor.rgb);
                sunAndMoon *= cloudsNegative;

                // Stars
                float3 stars = SAMPLE_TEXTURE2D(_Stars, sampler_Stars, skyUV + (_StarsSpeed * _Time.x)).rgb;
                stars *= saturate(-lightDir.y);
                stars = step(_StarsCutoff, stars);
                stars += (baseNoise * _StarsSkyColor.rgb);
                stars *= cloudsNegative;

                // Sky gradients
                float3 gradientDay = lerp(_DayBottomColor.rgb, _DayTopColor.rgb, saturate(horizon));
                float3 gradientNight = lerp(_NightBottomColor.rgb, _NightTopColor.rgb, saturate(horizon));
                float3 skyGradients = lerp(gradientNight, gradientDay, dayAmount) * cloudsNegative;

                // Sunset/rise
                float sunset = saturate((1 - horizon) * saturate(lightDir.y * 5));
                float3 sunsetColoured = sunset * _SunSet.rgb;

                // Horizon glow
                float3 horizonGlow = saturate((1 - horizon * 5) * saturate(lightDir.y * 10)) * _HorizonColorDay.rgb;
                float3 horizonGlowNight = saturate((1 - horizon * 5) * saturate(-lightDir.y * 10)) * _HorizonColorNight.rgb;
                horizonGlow += horizonGlowNight;

                float3 combined = skyGradients + sunAndMoon + sunsetColoured + stars + cloudsColored + horizonGlow;
                
                return float4(combined, 1);
            }
            ENDHLSL
        }
    }
    FallBack "Diffuse"
}
