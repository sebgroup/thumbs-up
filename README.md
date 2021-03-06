> A minimal voting system through github identities

## Background

This project was created as a help to help ensure the quality of internal documentation at SEB. It is integrated as an iframe where every documentation path serves as a page id. It shows all users the votes currently in place for that page id, but to be able to vote, the user needs to login in through github's oauth flow. It uses bitnamis version of postgres and is thus able to run in OpenShift environments without the need to run as root.

## Getting started

### PLEASE NOTE: This repo uses Font Awesome Pro icons

Since these are not freely distributed, you need to to either change the HTML to [include a different icon](https://fontawesome.com/icons/thumbs-up), or acquire a Font Awesome license key. To build with your key, create a [.npmrc file](https://docs.npmjs.com/files/npmrc) to the root of the project and [include the auth token](https://docs.npmjs.com/using-private-packages-in-a-ci-cd-workflow#create-and-check-in-a-project-specific-npmrc-file) there.

### Installation

1. `npm i`
2. `npm start` / `npm e2e-test`

or use docker compose

1. `docker-compose up`
2. step inside the container
3. run `npm start` / `npm e2e-test`

### Mocking github

When running the tests it is sometimes practical to mock the github endpoint. This is done with the nock npm package and is enabled with the `mockGithub` in settings.js

## Integration with your webpage

1. Create an [Oauth app](https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/).
2. Set the app Authorization callback URL to http://localhost:5000/authorized to run locally or where ever you are deploying + /authorized
3. Deploy the application (or fill in the docker-compose) somewhere with the following environment variables, they will be given to the application through settings.js:
   - githubUrl - either https://github.com or optionally an enterprise github installation e.g https://github.yourcompany.se
   - client_id - fetch this from your newly created Oauth app
   - client_secret - fetch this from your newly created Oauth app
   - state_password - a randomly generated string, preferably 32 characters
4. To make sure everything works accordingly, visit http://localhost:5000/?page_id=exampleid&redirect_uri=http://localhost:5000, if you are running locally. This should give you a working frame for voting for page id "exampleid". If you are able to login and place votes, everything is ready to be integrated in an iframe.
5. Create an iframe inside your application where the votes should take place with the necessary params (pageId, ), e.g:

   `<iframe id="thumbs-up-frame" src="<URL of the deployed THUMBS_UP service>?redirect_uri=<URL to be redirected to after authed>&page_id=<ID of the page to be voted upon>></iframe>`
