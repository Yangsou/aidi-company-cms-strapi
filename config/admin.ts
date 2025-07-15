export default ({ env }) => ({
  auth: {
    secret: env('ADMIN_JWT_SECRET'),
    enableAdminRegistration: false,
  },
  apiToken: {
    salt: env('API_TOKEN_SALT'),
  },
  transfer: {
    token: {
      salt: env('TRANSFER_TOKEN_SALT'),
    },
  },
  secrets: {
    encryptionKey: env('ENCRYPTION_KEY'),
  },
  flags: {
    nps: env.bool('FLAG_NPS', false),
    promoteEE: env.bool('FLAG_PROMOTE_EE', false),
  },
  // Disable Enterprise Edition trial features
  notifications: {
    releases: false,
  },
  // Disable trial features
  trial: {
    enabled: true,
  },
  // Disable video tutorials
  tutorials: false,
  // Disable auto-open admin panel
  autoOpen: false,
  // Admin panel configuration
  admin: {
    path: env('ADMIN_PATH', '/admin'),
    backendUrl: env('STRAPI_ADMIN_BACKEND_URL'),
  },
  // Telemetry configuration
  telemetry: {
    enabled: !env.bool('STRAPI_TELEMETRY_DISABLED', false),
  },
});
