export default {
  resource: 'admin.adminPlugins',
  path: '/plugins',
  map() {
    this.route('autopost', function () {
      this.route('campaigns');
    });
  }
};
