# Example OpenStax Exercises OAuth 2 Client

This app is an example of OAuth 2 client, based on the DoorKeeper [example client](https://github.com/applicake/doorkeeper-sinatra-client).

## Installation

Here are the steps for firing up this client app.

1. Run ````bundle install````.  This example directory has its own ````.ruby-version```` and ````.ruby-gemset```` files for setting up an RVM or RBEnv gem dir, so running ````bundle```` will not interfere with your OpenStax Exercises gem dir.
2. Create a [new oauth app](http://localhost:3000/oauth/applications/new) in your development instance of OpenStax Exercises.
3. Make the name of the application be "Example Client".  The redirect URI should be ````http://localhost:9292````.
3. Create an ````env.rb```` file in the top-level ````oauth-client```` directory that has the following contents, where the ````OAUTH2_CLIENT_ID```` and ````OAUTH2_CLIENT_SECRET```` have the appropriate values from the result of the prior step.

        # Change these hashes to match what your local version of Quadbase gives you
        ENV['OAUTH2_CLIENT_ID']           = "40348dc38..."
        ENV['OAUTH2_CLIENT_SECRET']       = "69d7e8493..."
        ENV['OAUTH2_CLIENT_REDIRECT_URI'] = "http://localhost:9292/callback"
4. Run ````rackup config.ru```` to start the server on port 9292.
5. Click the button to sign in
6. You'll be taken to a sign in screen on the OpenStax Exercises dev server
7. After signing in, you'll be taken back to the OAuth client, where you'll be asked if you want to authorize "Example Client" to have access to your OpenStax account.  Click "Authorize".
8. At this point, the example client can act as you in the OS Exercises dev server.  To explore the API is to append ````/explore/[API endpoint here]```` to the client's URL, e.g. ````http://localhost:9292/explore/dummy````.  The endpoint is whatever comes after ````/api/```` in the API docs.
