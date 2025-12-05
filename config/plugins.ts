export default () => ({
  "strapi-csv-import-export": {
    enable: true,
    config: {
      authorizedExports: [
        "api::machine.machine",
        "api::article.article",
        "api::job-location.job-location",
        "api::job-tag.job-tag",
        "api::product.product",
        "api::team-member.team-member",
        "api::activity.activity",
        "api::category.category",
        "api::job.job"
      ],
      authorizedImports: [
        "api::machine.machine",
        "api::article.article",
        "api::job-location.job-location",
        "api::job-tag.job-tag",
        "api::product.product",
        "api::team-member.team-member",
        "api::activity.activity",
        "api::category.category",
        "api::job.job"
      ],
    },
  },
});
