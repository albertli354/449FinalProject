/*
 Copyright 2016 Spotify AB

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** This protocol defines an object that can be played by `SPTAudioStreamingController`. */
@protocol SPTTrackProvider <NSObject>

/** Returns the tracks for playback if no player-supported URI. */
-(NSArray * _Nullable)tracksForPlayback;

/** Returns the URI to this set of tracks, nil if not supported by player. */
-(NSURL * _Nullable)playableUri;

@end

NS_ASSUME_NONNULL_END
