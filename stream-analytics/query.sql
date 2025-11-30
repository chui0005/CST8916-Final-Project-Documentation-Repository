
SELECT
    -- REQUIRED: unique document id
    CONCAT(
        IoTHub.ConnectionDeviceId,
        '-',
        CAST(System.Timestamp AS nvarchar(max))
    ) AS id,

    -- REQUIRED: partition key (must match container)
    IoTHub.ConnectionDeviceId AS location,

    -- REQUIRED: must be named exactly 'timestamp'
    System.Timestamp AS timestamp,

    -- Ice thickness (cm)
    AVG(ice_thickness_cm)        AS avgIceThicknessCm,
    MIN(ice_thickness_cm)        AS minIceThicknessCm,
    MAX(ice_thickness_cm)        AS maxIceThicknessCm,

    -- Surface temperature (°C)
    AVG(surface_temperature_c)   AS avgSurfaceTemperatureC,
    MIN(surface_temperature_c)   AS minSurfaceTemperatureC,
    MAX(surface_temperature_c)   AS maxSurfaceTemperatureC,

    -- Snow accumulation (cm)
    MAX(snow_accumulation_cm)    AS maxSnowAccumulationCm,

    -- External temperature (°C)
    AVG(external_temperature_c)  AS avgExternalTemperatureC,

    -- Reading count
    COUNT(*)                     AS eventCount

INTO [cosmosoutput]
FROM [input]
TIMESTAMP BY timestamp
GROUP BY
    IoTHub.ConnectionDeviceId,
    TUMBLINGWINDOW(minute, 5)


SELECT
    IoTHub.ConnectionDeviceId AS location,
    System.Timestamp AS windowEndTime,

    -- Ice thickness (cm)
    AVG(ice_thickness_cm)        AS avgIceThicknessCm,
    MIN(ice_thickness_cm)        AS minIceThicknessCm,
    MAX(ice_thickness_cm)        AS maxIceThicknessCm,

    -- Surface temperature (°C)
    AVG(surface_temperature_c)   AS avgSurfaceTemperatureC,
    MIN(surface_temperature_c)   AS minSurfaceTemperatureC,
    MAX(surface_temperature_c)   AS maxSurfaceTemperatureC,

    -- Snow accumulation (cm)
    MAX(snow_accumulation_cm)    AS maxSnowAccumulationCm,

    -- External temperature (°C)
    AVG(external_temperature_c)  AS avgExternalTemperatureC,

    -- Count of readings
    COUNT(*)                     AS eventCount


INTO [bloboutput]
FROM [input]
TIMESTAMP BY timestamp
GROUP BY
    IoTHub.ConnectionDeviceId,
    TUMBLINGWINDOW(minute, 5)
