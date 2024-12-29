module.exports = {
  apps: [
    {
      name: "Alphawax Staging",
      cwd: "/var/www/staging/",
      script: "/var/www/staging/app/server.js",
      instances: "max",
      exec_mode: "cluster",
      env: {
        NODE_ENV: "development",
        APP_PORT: 8001,
        APP_SITE_FOLDER: "../sites/alphawax.com"
      }
    },
    {
      name: "Hywax Staging",
      cwd: "/var/www/staging/",
      script: "/var/www/staging/app/server.js",
      instances: "max",
      exec_mode: "cluster",
      env: {
        NODE_ENV: "development",
        APP_PORT: 8002,
        APP_SITE_FOLDER: "../sites/hywax.com"
      }
    },
    {
      name: "SER Staging",
      cwd: "/var/www/staging/",
      script: "/var/www/staging/app/server.js",
      instances: "max",
      exec_mode: "cluster",
      env: {
        NODE_ENV: "development",
        APP_PORT: 8003,
        APP_SITE_FOLDER: "../sites/serwax.com"
      }
    },
    {
      name: "Alphawax Production",
      cwd: "/var/www/production/",
      script: "/var/www/production/app/server.js",
      instances: "max",
      exec_mode: "cluster",
      env: {
        NODE_ENV: "production",
        APP_PORT: 8011,
        APP_SITE_FOLDER: "../sites/alphawax.com"
      }
    },
    {
      name: "Hywax Production",
      cwd: "/var/www/production/",
      script: "/var/www/production/app/server.js",
      instances: "max",
      exec_mode: "cluster",
      env: {
        NODE_ENV: "production",
        APP_PORT: 8012,
        APP_SITE_FOLDER: "../sites/hywax.com"
      }
    },
    {
      name: "SER Production",
      cwd: "/var/www/production/",
      script: "/var/www/production/app/server.js",
      instances: "max",
      exec_mode: "cluster",
      env: {
        NODE_ENV: "production",
        APP_PORT: 8013,
        APP_SITE_FOLDER: "../sites/serwax.com"
      }
    },
  ]
}
