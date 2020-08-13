module.exports = {
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
    "@semantic-release/npm",
    "@semantic-release/github",
    "@semantic-release/git",
    ["@semantic-release/exec", {
      "prepareCmd": "docker build -t zhj2074/bash-base ."
    }],
    ["semantic-release-docker", {
      "name": "zhj2074/bash-base"
    }]
  ]
}
