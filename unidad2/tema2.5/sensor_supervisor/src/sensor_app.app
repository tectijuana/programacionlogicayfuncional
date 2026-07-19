%% Archivo de recursos de la aplicación OTP.
%% Sin este archivo, application:start(sensor_app) falla con
%% {error, {"no such file or directory", "sensor_app.app"}}.
{application, sensor_app,
 [{description, "Monitor de sensores IoT estilo CENAPRED — tema 2.5"},
  {vsn, "1.0.0"},
  {modules, [sensor_app, sensor_sup, sensor_server]},
  {registered, [sensor_sup, temperatura, humedad, presion]},
  {applications, [kernel, stdlib]},
  {mod, {sensor_app, []}}]}.
