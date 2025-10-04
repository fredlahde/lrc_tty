//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#ifndef APPLEMUSICCTRL_H
#define APPLEMUSICCTRL_H

#ifdef __cplusplus
extern "C" {
#endif

typedef void* AppleMusicCtrlRef;

AppleMusicCtrlRef AppleMusicCtrl_create(void);
void AppleMusicCtrl_compile(AppleMusicCtrlRef);
void AppleMusicCtrl_destroy(AppleMusicCtrlRef);

const char* AppleMusicCtrl_get_song_name(AppleMusicCtrlRef);
const char* AppleMusicCtrl_get_album_name(AppleMusicCtrlRef);
const char* AppleMusicCtrl_get_artist_name(AppleMusicCtrlRef);
const char* AppleMusicCtrl_get_play_time(AppleMusicCtrlRef);

#ifdef __cplusplus
}
#endif

#endif // APPLEMUSICCTRL_H

