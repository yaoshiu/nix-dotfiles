{...}: {
  services.spark = {
    master = {
      enable = true;
      bind = "127.0.0.1";
      extraEnvironment = {
        SPARK_DRIVER_MEMORY = "1024m";
      };
    };

    worker = {
      enable = true;
      extraEnvironment = {
        SPARK_WORKER_MEMORY = "1024m";
      };
    };
  };
}
