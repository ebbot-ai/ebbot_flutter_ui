# Troubleshooting Guide

Common issues and solutions for Ebbot Flutter UI.

## Installation Issues

### Dependency Resolution Errors

**Error:** `Could not resolve package:ebbot_flutter_ui`

**Solutions:**
1. Check your `pubspec.yaml` syntax:
   ```yaml
   dependencies:
     ebbot_flutter_ui:
       git:
         url: https://github.com/ebbot-ai/ebbot_flutter_ui
         ref: main
   ```

2. Ensure you have access to the repository
3. Try cleaning and getting dependencies:
   ```bash
   flutter clean
   flutter pub get
   ```

### Import Errors

**Error:** `Target of URI doesn't exist: 'package:ebbot_flutter_ui/ebbot_flutter_ui.dart'`

**Solutions:**
1. Verify the package is installed:
   ```bash
   flutter pub deps
   ```

2. Check import path:
   ```dart
   import 'package:ebbot_flutter_ui/ebbot_flutter_ui.dart';
   ```

3. Restart your IDE and run `flutter pub get`

## Initialization Issues

### Chat Not Loading

**Symptoms:**
- Spinner never stops
- Blank white screen
- No error messages

**Solutions:**

1. **Check bot ID:**
   ```dart
   EbbotFlutterUi(
     botId: 'your-actual-bot-id', // Verify this is correct
     configuration: configuration,
   )
   ```

2. **Enable logging:**
   ```dart
   .logConfiguration(
     EbbotLogConfigurationBuilder()
       .enabled(true)
       .logLevel(EbbotLogLevel.debug)
       .build()
   )
   ```

3. **Check network connectivity:**
   - Ensure device has internet access
   - Check if corporate firewall blocks WebSocket connections
   - Verify the environment setting

4. **Add error callback:**
   ```dart
   .callback(
     EbbotCallbackBuilder()
       .onLoadError((error) {
         print('Load error: ${error.type} - ${error.cause}');
       })
       .build()
   )
   ```

### Connection Timeout

**Error:** `Connection timeout` or `WebSocket failed to connect`

**Solutions:**

1. **Check environment:**
   ```dart
   .environment(Environment.production) // Use correct environment
   ```

2. **Test different environments:**
   ```dart
   .environment(Environment.staging) // Try staging first
   ```

3. **Check network settings:**
   - Disable VPN temporarily
   - Try different network (mobile data vs WiFi)
   - Check corporate proxy settings

## Configuration Issues

### Configuration Not Applied

**Symptoms:**
- Settings don't take effect
- Default values used instead

**Solutions:**

1. **Ensure `.build()` is called:**
   ```dart
   final configuration = EbbotConfigurationBuilder()
     .environment(Environment.production)
     .build(); // Don't forget this!
   ```

2. **Pass configuration to widget:**
   ```dart
   EbbotFlutterUi(
     botId: 'your-bot-id',
     configuration: configuration, // Include this line
   )
   ```

3. **Check builder chain:**
   ```dart
   .userConfiguration(
     EbbotUserConfigurationBuilder()
       .userAttributes({'userId': '123'})
       .build() // Each builder needs .build()
   )
   ```

### Callbacks Not Firing

**Symptoms:**
- `onLoad`, `onMessage`, etc. not called
- Events not tracked

**Solutions:**

1. **Verify callback registration:**
   ```dart
   .callback(
     EbbotCallbackBuilder()
       .onLoad(() => print('This should print'))
       .build() // Don't forget .build()
   )
   ```

2. **Check async/await:**
   ```dart
   .onLoad(() async {
     // Use async if needed
     await someAsyncOperation();
   })
   ```

3. **Test with simple callbacks first:**
   ```dart
   .onLoad(() => debugPrint('Chat loaded'))
   .onLoadError((error) => debugPrint('Error: $error'))
   ```

## API Controller Issues

### Methods Not Working

**Error:** `StateError: EbbotClientService is not initialized`

**Solutions:**

1. **Check initialization:**
   ```dart
   if (apiController.isInitialized()) {
     apiController.sendMessage('Hello');
   } else {
     print('Controller not ready yet');
   }
   ```

2. **Wait for onLoad callback:**
   ```dart
   .callback(
     EbbotCallbackBuilder()
       .onLoad(() {
         // Now it's safe to use API controller
         apiController.sendMessage('Chat is ready!');
       })
       .build()
   )
   ```

3. **Verify controller is passed to configuration:**
   ```dart
   final apiController = EbbotApiController();
   
   final configuration = EbbotConfigurationBuilder()
     .apiController(apiController) // Must include this
     .build();
   ```

### Commands Not Executed

**Symptoms:**
- `sendMessage()` doesn't work
- No response from API calls

**Solutions:**

1. **Check timing:**
   ```dart
   // Wrong - too early
   EbbotFlutterUi(/*...*/);
   apiController.sendMessage('Hello'); // This will fail
   
   // Right - wait for initialization
   .onLoad(() {
     apiController.sendMessage('Hello'); // This works
   })
   ```

2. **Add error handling:**
   ```dart
   try {
     if (apiController.isInitialized()) {
       apiController.sendMessage('Hello');
     }
   } catch (e) {
     print('API error: $e');
   }
   ```

## Styling Issues

### Theme Not Applied

**Symptoms:**
- Custom colors not showing
- Default theme used instead

**Solutions:**

1. **Check theme configuration:**
   ```dart
   .chat(
     EbbotChatBuilder()
       .theme(const DarkChatTheme()) // Ensure theme is set
       .build()
   )
   ```

2. **Verify theme class:**
   ```dart
   class CustomTheme extends DefaultChatTheme {
     const CustomTheme() : super(
       primaryColor: Color(0xFF2196F3), // Custom color
     );
   }
   ```

3. **Hot reload limitations:**
   - Stop and restart the app for theme changes
   - Themes may not update with hot reload

### Custom Widgets Not Showing

**Symptoms:**
- Rating icons not appearing
- Custom elements missing

**Solutions:**

1. **Check widget size constraints:**
   ```dart
   .rating(
     SizedBox(
       width: 30,
       height: 30,
       child: Icon(Icons.star_border),
     )
   )
   ```

2. **Verify both rating states:**
   ```dart
   .rating(unselectedIcon)        // Required
   .ratingSelected(selectedIcon)  // Required
   ```

## Performance Issues

### Slow Loading

**Symptoms:**
- Long initialization time
- UI freezing during load

**Solutions:**

1. **Disable unnecessary logging:**
   ```dart
   .logConfiguration(
     EbbotLogConfigurationBuilder()
       .enabled(false) // Disable in production
       .build()
   )
   ```

2. **Optimize user attributes:**
   ```dart
   // Don't send too much data
   .userAttributes({
     'userId': user.id, // Essential only
     'name': user.name,
   })
   ```

3. **Use appropriate log levels:**
   ```dart
   .logLevel(EbbotLogLevel.error) // Minimal logging
   ```

### Memory Issues

**Symptoms:**
- App crashes
- High memory usage

**Solutions:**

1. **Check for memory leaks:**
   - Ensure you're not holding references to the widget
   - The widget handles disposal automatically
   
2. **Reduce logging in production:**
   ```dart
   .logConfiguration(
     EbbotLogConfigurationBuilder()
       .enabled(false) // Disable logging in production
       .build()
   )
   ```

## Platform-Specific Issues

### iOS Issues

**Problem:** Build errors on iOS

**Solutions:**
1. Update iOS deployment target to 11.0+
2. Run `cd ios && pod install`
3. Clean and rebuild: `flutter clean && flutter build ios`

### Android Issues

**Problem:** Build errors on Android

**Solutions:**
1. Check minimum SDK version (API 21+)
2. Ensure internet permission in `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.INTERNET" />
   ```

### Web Issues

**Problem:** Connection issues in web browsers

**Solutions:**
1. Check browser console for WebSocket connection errors
2. Verify the environment supports web connections
3. Test in different browsers to isolate browser-specific issues

## Environment Issues

### Wrong Environment

**Symptoms:**
- Bot not found
- Configuration errors
- Connection failures

**Solutions:**

1. **Verify environment mapping:**
   ```dart
   // For production bots
   .environment(Environment.googleEUProduction)
   
   // For staging/test bots  
   .environment(Environment.staging)
   ```

2. **Check with your Ebbot admin:**
   - Confirm bot ID
   - Verify correct environment
   - Check bot status

3. **Test with staging first:**
   ```dart
   .environment(Environment.staging) // Always test here first
   ```

## Debugging Tools

### Enable Verbose Logging

```dart
final debugConfig = EbbotConfigurationBuilder()
  .logConfiguration(
    EbbotLogConfigurationBuilder()
      .enabled(true)
      .logLevel(EbbotLogLevel.debug)
      .build()
  )
  .callback(
    EbbotCallbackBuilder()
      .onLoad(() => debugPrint('✅ Chat loaded'))
      .onLoadError((error) => debugPrint('❌ Load error: $error'))
      .onMessage((msg) => debugPrint('💬 Message: $msg'))
      .build()
  )
  .build();
```

### Network Debugging

```dart
// Add to onLoadError callback
.onLoadError((error) {
  if (error.type == EbbotInitializationErrorType.network) {
    debugPrint('Network issue detected');
    debugPrint('Check internet connection');
    debugPrint('Verify environment setting');
    debugPrint('Try different network');
  }
})
```

### Configuration Validation

```dart
void validateConfiguration(EbbotConfiguration config) {
  assert(config.environment != null, 'Environment must be set');
  assert(config.apiController != null, 'API controller recommended');
  debugPrint('Configuration valid ✅');
}
```

## Getting Help

If you're still experiencing issues:

1. **Check the logs** with debug level enabled
2. **Try the example app** to isolate the issue
3. **Test with minimal configuration** first
4. **Create a GitHub issue** with:
   - Flutter version (`flutter --version`)
   - Error messages and stack traces
   - Minimal reproduction code
   - Platform details

5. **Contact the development team** with:
   - Bot ID (if not sensitive)
   - Environment being used
   - Configuration snippet
   - Error details

## Quick Fixes Checklist

- [ ] Correct import path used
- [ ] Bot ID is valid
- [ ] Environment matches bot
- [ ] `.build()` called on all builders
- [ ] Configuration passed to widget
- [ ] Network connectivity available
- [ ] Latest Flutter version
- [ ] Debug logging enabled
- [ ] Error callbacks implemented

