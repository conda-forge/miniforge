const https = require('https')
const options = {
  hostname: 'api.anaconda.org',
  port: 443,
  path: '/package/conda-forge/conda',
  method: 'GET'
}

function compareVersions(version1, version2) {
  ver1 = version1.split(".").map(Number);
  ver2 = version2.split(".").map(Number);

  const common_length = Math.min(ver1.length, ver2.length);
  for (var i = 0; i < common_length; ++i) {
    if (ver1[i] < ver2[i]) {
      return -1;
    } else if (ver1[i] > ver2[i]) {
      return 1;
    }
  }

  if (ver1.length > common_length) {
    return 1;
  } else if (ver2.length > common_length) {
    return -1;
  } else {
    return 0;
  }
}

module.exports = ({github, context}) => {
  const req = https.request(options, res => {
    var data = '';

    res.on('data', chunk => {
      data += chunk;
    });

    res.on('end', function () {
      versions = JSON.parse(data)["files"].map(x => x["version"]);
      versions.sort(compareVersions);
      conda_version = versions.pop();

      github.rest.repos.getLatestRelease({
        owner: context.repo.owner,
        repo: context.repo.repo,
      }).then((release) => {
        const current_version = release['data']['tag_name'].split("-")[0]
        if (compareVersions(conda_version, current_version) === 1) {
          github.rest.issues.listForRepo({
              owner: context.repo.owner,
              repo: context.repo.repo,
              state: "open",
              labels: "[bot] conda release"
          }).then((issues) => {
            if (issues.data.length === 0) {
              github.rest.issues.create({
                owner: context.repo.owner,
                repo: context.repo.repo,
                title: "New conda release: please tag a miniforge release",
                body: "A new conda release was found, please tag a new miniforge release with `" + conda_version + "-0`",
                labels: ["[bot] conda release"]
              })
            }
          });
        }
      });
    });
  })

  req.end();
}
