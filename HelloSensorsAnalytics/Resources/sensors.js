(function(para) {
 var p = para.sdk_url, n = para.name, w = window, d = document, s = 'script',x = null,y = null;
 if(typeof(w['sensorsDataAnalytic201505']) !== 'undefined') {
 return false;
 }
 w['sensorsDataAnalytic201505'] = n;
 w[n] = w[n] || function(a) {return function() {(w[n]._q = w[n]._q || []).push([a, arguments]);}};
 var ifs = ['track','quick','register','registerPage','registerOnce','trackSignup', 'trackAbtest', 'setProfile','setOnceProfile','appendProfile', 'incrementProfile', 'deleteProfile', 'unsetProfile', 'identify','login','logout','trackLink','clearAllRegister','getAppStatus'];
 for (var i = 0; i < ifs.length; i++) {
 w[n][ifs[i]] = w[n].call(null, ifs[i]);
 }
 if (!w[n]._t) {
 x = d.createElement(s), y = d.getElementsByTagName(s)[0];
 x.async = 1;
 x.src = p;
 x.setAttribute('charset','UTF-8');
 y.parentNode.insertBefore(x, y);
 w[n].para = para;
 }
 })({
    sdk_url: 'https://static.sensorsdata.cn/sdk/1.12.8/sensorsdata.min.js',
    heatmap_url: 'https://static.sensorsdata.cn/sdk/1.12.8/heatmap.min.js',
    server_url: 'https://sensorsdata.cn',
    name: 'sensors',
    use_app_track: true,
    heatmap:{}
    });
 sensors.quick('autoTrack');
