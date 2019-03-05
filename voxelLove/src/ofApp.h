#pragma once

#include "ofMain.h"
#include "ofxGui.h"

#define RES_ALL 160
#define RES_Z RES_ALL
#define RES_Y RES_ALL
#define RES_X RES_ALL
#define TOTAL_RES RES_Z * RES_Y * RES_X

class ofApp : public ofBaseApp{
    
public:
    void setup();
    void update();
    void draw();
    
    void keyPressed(int key);
    void keyReleased(int key);
    void mouseMoved(int x, int y );
    void mouseDragged(int x, int y, int button);
    void mousePressed(int x, int y, int button);
    void mouseReleased(int x, int y, int button);
    void mouseEntered(int x, int y);
    void mouseExited(int x, int y);
    void windowResized(int w, int h);
    void dragEvent(ofDragInfo dragInfo);
    void gotMessage(ofMessage msg);
    
    bool hideCursorPressed();
    
    ofShader shader;
    ofVbo vbo;
    
    ofIndexType ind[TOTAL_RES];
    ofVec3f vVecs[TOTAL_RES];
    
    ofEasyCam cam;
    ofVec3f camPos;
    ofVec3f camLookAt;
    
    ofxPanel gui;
    bool showGui;
    ofxVec3Slider controlSlider;
    ofxToggle lockCamera;
    bool isCursorHidden;
    
};
