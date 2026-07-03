# zepto-react-native

Zepto's Android-native fork of [`facebook/react-native`](https://github.com/facebook/react-native).
It publishes two prebuilt Android AARs consumed by `zepto-customer-app`:

- `com.facebook.react:react-android:<rnVersion>`
- `com.facebook.hermes:hermes-android:<hermesVersion>`

iOS still builds React from source, so these AARs are Android-only.

## How to read tags / releases

| | Pattern | Example | Description |
|---|---|---|---|
| Clean branch | `v<rnVersion>` | `v0.85.3` | RN's actual branch |
| Base branch | `zepto/<rnVersion>` | `zepto/0.85.3` | The updated RN branch with all of our changes merged. Never delete this. |
| Feature branch | `feature/<rnVersion>-zepto-release-<N>` | `feature/0.85.3-zepto-release-2` | The branch to create in order to push a patch or fix |
| S3 upload path | `rn-<rnVersion>-release-<N>` | `rn-0.85.3-release-2` | The folder name in S3 corresponding to a particular release |

The app routes both `com.facebook.react` and `com.facebook.hermes` to that release
via `includeGroup`.

**Hermes V1** is off by default. To toggle it, flip both in `gradle.properties`:
`hermesV1Enabled` and `react.internal.useHermesStable` (`false` = classic, `true` = V1).

## How to generate locally

```bash
./scripts/build-android-aars.sh [OUTPUT_DIR]
```

| arg | meaning | default |
|---|---|---|
| `OUTPUT_DIR` | where to write the local maven repo | `/tmp/maven-local` |

```bash
./scripts/build-android-aars.sh                # -> /tmp/maven-local
./scripts/build-android-aars.sh ~/zepto-aars   # -> custom dir
```

It runs `./gradlew publishAllToMavenTempLocal -PaarOutputRepo="file://<OUTPUT_DIR>"`, which
publishes both AARs — `react-android` (`ReactAndroid/publish.gradle`) and `hermes-android`
(`ReactAndroid/hermes-engine/build.gradle.kts`). Output:

```
<OUTPUT_DIR>/com/facebook/react/react-android/<rnVersion>/
<OUTPUT_DIR>/com/facebook/hermes/hermes-android/<hermesVersion>/
```

To consume a local build, replace the Phoenix repo in
`zepto-customer-app/android/build.gradle` with:

```groovy
maven {
    url "file:///tmp/maven-local"   // or your OUTPUT_DIR
    content {
        includeGroup("com.facebook.react")
        includeGroup("com.facebook.hermes")
    }
}
```

Requires Android SDK + NDK and JDK 17.
