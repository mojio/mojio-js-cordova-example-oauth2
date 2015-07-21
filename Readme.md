
ionic build ios
ionic run ios

tail -f  [Project Directory]/platforms/ios/cordova/console.log

e.g.

tail -f  ~/Code/cordova/ionCordova/platforms/ios/cordova/console.log

To make this work, the inappbrowser must be installed for the build platform:

cordova plugin add org.apache.cordova.inappbrowser

Need the console plugin: 

cordova plugin add org.apache.cordova.console
