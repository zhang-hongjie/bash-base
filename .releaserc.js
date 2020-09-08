module.exports = {
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
    "@semantic-release/npm",
    ["@semantic-release/exec", {
      "prepareCmd": "docker build -t renaultdigital/bash-base . && npm run livedoc"
    }],
    ["@semantic-release/git", {
      "assets": ['CHANGELOG.md', 'package.json', 'package-lock.json', 'npm-shrinkwrap.json', 'src', 'docs', 'man'],
      "message": "chore(release): ${nextRelease.version} [skip ci]"
    }],
    "@semantic-release/github",
    ["semantic-release-docker", {
      "name": "renaultdigital/bash-base"
    }]
  ]
}
