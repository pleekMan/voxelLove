#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofBackground(0);
    
    // LOAD SHADER
    shader.load("shaders/4_noise3D_InfinityMirror.vert","shaders/shader.frag"); // REPLACE WITH THE DIFFERENT SHADER IN THE FOLDER
    
    // CAMERA SETUP
    //cam.setAutoDistance(false);
    float pseudoDistance = 280;
    float yOffset = 0;
    camPos = ofVec3f(pseudoDistance);
    //camPos.y += yOffset;
    camLookAt = ofVec3f(0,yOffset,0);
    //cam.lookAt(ofVec3f(0,30,0)); // AT draw(). OTHERWISE, NOT WORKING..
    cam.setNearClip(10.f);
    cam.setFarClip(10000.f);
    //cam.disableMouseInput();
    //cam.setPosition(camPos);
    //cam.rotateAround(20, ofVec3f(0,1,0), ofVec3f(0));
    
    
    
    // GUI STUFF
    showGui = true;
    gui.setup();
    gui.add(uvwSlider.setup("U|V|W", ofVec3f(0.5), ofVec3f(-1), ofVec3f(1)));
    gui.add(lockCamera.setup("CAMERA LOCK", true));
    
    
    // SETUP VOXEL CUBE
    float sep = 1.0 / RES_X;
    for (int z = 0; z < RES_Z; z++) {
        for (int y = 0; y < RES_Y; y++) {
            for (int x = 0; x < RES_X; x++) {
                int arrayPos = x + (y*RES_X) + (z*RES_X*RES_Y);
                vVecs[arrayPos] = ofVec3f(x * sep, y * sep, z * sep);
                ind[arrayPos] = arrayPos;
            }
        }
    }
    vbo.setVertexData(vVecs, TOTAL_RES, GL_STATIC_DRAW);
    vbo.setIndexData(&ind[0], TOTAL_RES, GL_STATIC_DRAW);
    glPointSize(1);

}

//--------------------------------------------------------------
void ofApp::update(){
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofSetWindowTitle(ofToString(ofGetFrameRate()));
    
    
    if(lockCamera){
        cam.setPosition(camPos);
        cam.lookAt(camLookAt);
    }
    
    
    //cam.setDistance((ofGetFrameNum() * ofGetFrameNum()) * 0.05);
    cam.begin();
    
    shader.begin();
    shader.setUniform1f("time", ofGetFrameNum());
    shader.setUniform3f("uvwControl", uvwSlider);
    shader.setUniform2f("mouse", ofGetMouseX(), ofGetMouseY());
    shader.setUniform2f("resolution", ofGetWindowSize());
    
    //ofDrawAxis(50);
    
    vbo.drawElements(GL_POINTS, TOTAL_RES);
  
    shader.end();
    cam.end();
    
    if(showGui)gui.draw();
    
    
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    if (key == 'i' || key == 'I')camPos *= ofVec3f(-1,1,-1);
    if (key == 'g' || key == 'G')showGui = !showGui;
    if (key == 'l' || key == 'L')lockCamera = !lockCamera;
    if (key == 'c' || key == 'C')hideCursorPressed();


}

bool ofApp::hideCursorPressed(){
    if (isCursorHidden) {
        ofShowCursor();
    } else {
        ofHideCursor();
    }
    return isCursorHidden = !isCursorHidden;
}


//--------------------------------------------------------------
void ofApp::keyReleased(int key){
    
}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){
    
}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){
    
}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){
    
}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){
    
}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){
    
}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){
    
}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){
    
}
