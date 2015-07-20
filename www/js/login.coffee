angular.module('starter.services', [])
    .factory('LoginService',
        ($rootScope) ->
            data =
                token: 'none'

#            login2 = (clientId, appScope, options) ->
#                deferred = $q.defer();
#                if(window.cordova)
#                    clientId = "576f5522-9b0c-4f1a-82d4-4b4fbb7272bc"
#                    if($cordovaOauthUtility.isInAppBrowserInstalled(cordovaMetadata) == true)
#                        redirect_uri = "http://localhost/callback";
#                        if(options != undefined)
#                            if(options.hasOwnProperty("redirect_uri"))
#                                redirect_uri = options.redirect_uri;
#
#                        browserRef = window.open('https://api.moj.io/OAuth2/authorize?client_id=' + clientId +
#                                '&redirect_uri='+ redirect_uri + '&response_type=token', '_blank', 'location=no,clearsessioncache=yes,clearcache=yes');
#                        browserRef.addEventListener('loadstart', (event) ->
#                            if ((event.url).indexOf(redirect_uri) == 0)
#                                browserRef.removeEventListener("exit", ((event) ->))
#                                browserRef.close()
#                                callbackResponse = (event.url).split("#")[1]
#                                responseParameters = (callbackResponse).split("&")
#                                parameterMap = []
#                                for i in [0...responseParameters.length]
#                                    parameterMap[responseParameters[i].split("=")[0]] = responseParameters[i].split("=")[1]
#
#                                if(parameterMap.access_token != undefined && parameterMap.access_token != null)
#                                    deferred.resolve({ access_token: parameterMap.access_token, expires_in: parameterMap.expires_in })
#                                else
#                                    if ((event.url).indexOf("error_code=100") != 0)
#                                        deferred.reject("Mojio returned error_code=100: Invalid permissions");
#                                    else
#                                        deferred.reject("Problem authenticating")
#                        )
#                        browserRef.addEventListener('exit', (event) ->
#                             deferred.reject("The sign in flow was canceled");
#                        )
#                     else
#                         deferred.reject("Could not find InAppBrowser plugin");
#                return deferred.promise

            login = () ->
                clientId = "576f5522-9b0c-4f1a-82d4-4b4fbb7272bc"
                ref = window.open('https://api.moj.io/OAuth2/authorize?client_id=' + clientId +
                        '&redirect_uri=http://localhost/callback&response_type=token', '_blank', 'location=no,presentationstyle=fullscreen,hardwareback=no,clearsessioncache=yes,clearcache=yes')
                ref.addEventListener('loadstart', (event) ->
                    if ((event.url).indexOf("http://localhost/callback") == 0)
                        ref.removeEventListener("exit", ((event) ->))
                        ref.close()
                        console.log("Event url: " + event.url)
                        if (event.url.indexOf("access_token=") >= 0)
                            $rootScope.data = {} if !$rootScope.data?
                            $rootScope.data.LoggedIn = true
                            $rootScope.$apply (() ->
                                data.token = (event.url).split("access_token=")[1].split("&")[0]
                            )

                )
                ref.addEventListener('loadstop', () ->
#                    ref.executeScript( code: "document.getElementsByClassName('sf-menu')[0].style.display='none'" )
#                    ref.executeScript( code: "document.getElementsByClassName('icon-reorder')[0].style.display='none'" )
                    console.log('Load Stop!')
                )
                ref.addEventListener('exit', (event) ->
                    console.log('Exit! ')
#                    if (!$rootScope.data.LoggedIn)
#                        login()
                )

                console.log('Login setup complete. ')


            logout = () ->
                $rootScope.data.LoggedIn = false
                data.token = "none"
                ref = null
                console.log('Logout: ')
                clientId = "576f5522-9b0c-4f1a-82d4-4b4fbb7272bc"

                ref = window.open('https://api.moj.io/account/logout?Guid=' + data.token + '&client_id=' + clientId +
                    '&redirect_uri=http://localhost/callback',
                    '_blank', 'location=no,hidden=yes,hardwareback=no')

                ref.addEventListener('loadstart', (event) ->
                    console.log('Logout started. '+JSON.stringify(event))
                )
                ref.addEventListener('loaderror', (event) ->
                    console.log('Logout error. '+JSON.stringify(event))
                    $rootScope.data.LoggedIn = false
                    ref.close()
                    login()
                )
                ref.addEventListener('loadstop', (event) ->
                    console.log('Logout finished. '+JSON.stringify(event))
                    $rootScope.data.LoggedIn = false
                    ref.close()
                    login()
                )

            return {
                    login: login,
                    logout: logout,
                    data: data
                }

)