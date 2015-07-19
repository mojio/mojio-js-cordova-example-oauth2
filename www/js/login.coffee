angular.module('starter.services', [])
    .factory('LoginService',
        ($rootScope) ->
            data =
                token: 'none'

            login = () ->
                clientId = "576f5522-9b0c-4f1a-82d4-4b4fbb7272bc"

                ref = window.open('https://api.moj.io/OAuth2/authorize?client_id=' + clientId +
                        '&redirect_uri=http://localhost/callback&response_type=token', '_blank', 'location=no,presentationstyle=fullscreen,hardwareback=no')
#                ref.addEventListener('loadstop', () ->
#                    ref.executeScript( code: "document.getElementsByClassName('sf-menu')[0].style.display='none'" )
#                    ref.executeScript( code: "document.getElementsByClassName('icon-reorder')[0].style.display='none'" )
#                )
                ref.addEventListener('exit', (event) ->
#                    if (!$rootScope.data.LoggedIn)
#                        login()
                )
                ref.addEventListener('loadstart', (event) ->
                    console.log('Login Result: ')
                    if ((event.url).indexOf("http://localhost/callback") == 0)
                        console.log("Event url: " + event.url)
                        if (event.url.indexOf("access_token=") >= 0)
                            $rootScope.data.LoggedIn = true
                            $rootScope.$apply (() ->
                                data.token = (event.url).split("access_token=")[1].split("&")[0]
                            )
                            ref.close()
                )

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