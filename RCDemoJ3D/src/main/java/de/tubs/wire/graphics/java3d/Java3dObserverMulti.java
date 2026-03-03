/*
 * Copyright (C) 2016 ezander
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package de.tubs.wire.graphics.java3d;

import de.tubs.wire.graphics.ViewController;
import de.tubs.wire.graphics.camera.Camera;
import de.tubs.wire.graphics.camera.CameraFactory;
import de.tubs.wire.graphics.camera.CameraView;
import de.tubs.wire.simulator.TrackSimulator;
import de.tubs.wire.simulator.track.Track;
import de.tubs.wire.simulator.track.TrackInformation;
import org.jogamp.java3d.*;
import org.jogamp.vecmath.Point3d;
import org.jogamp.vecmath.Vector3d;

import java.util.ArrayList;
import java.util.List;


/**
 *
 * @author ezander
 */
public class Java3dObserverMulti extends Java3dObserverBase {
    
    VirtualUniverse universe;
    List<ViewInfo> views = new ArrayList<>(2);
    public TrackSimulator sim;
    
    public ViewInfo addView(Canvas3D canvas) {
        assert universe == null;
        
        ViewInfo viewinfo = new ViewInfo(canvas);
        views.add(viewinfo);
        // setCamNum(camNum);
        return viewinfo;
    }
    
    @Override
    public void init(TrackInformation trackInfo) {
        this.trackInfo = trackInfo;
        this.track = trackInfo.getTrack();
        assert (track != null);

        //
        world = createWorld();
        branchGroup = new BranchGroup();
        branchGroup.setCapability(BranchGroup.ALLOW_DETACH);
        branchGroup.addChild(world);

        class UpdateBehavior extends Behavior {
            //private final WakeupCondition wakeup = new WakeupOnElapsedFrames(6);
            private final WakeupCondition wakeup = new WakeupOnElapsedTime(30);

            public void initialize() {
                wakeupOn(wakeup);
            }

            public void processStimulus(java.util.Iterator criteria) {
                sim.update();
                wakeupOn(wakeup);
            }
        }
        Behavior behavior = new UpdateBehavior();
        behavior.setSchedulingBounds(new BoundingSphere(new Point3d(0.0, 0.0, 0.0), 1000.0));
        branchGroup.addChild(behavior);
        branchGroup.compile();

        // Create the universe and add the group of objects
        for (ViewInfo view : views) {
            view.init();
            view.canvas.stopRenderer();
        }

        universe = new VirtualUniverse();
        Locale locale = new Locale(universe);
        locale.addBranchGraph(branchGroup);
        for (ViewInfo view : views) {
            locale.addBranchGraph(view.viewBranch);
            view.setCamNum(view.getCamNum());
        }

        for (ViewInfo view : views) {
            view.canvas.validate();
            view.canvas.startRenderer();
        }

    }
    
    @Override
    public void notify(double t, double[] y) {
        super.notify(t, y);
        double s = y[0];
        double dsdt = y[1];

        for (ViewInfo view : views) {
            CameraView<Vector3d> camView = view.camera.getView(s, dsdt);
            Transform3D transform = new Transform3D();
            transform.lookAt(
                    new Point3d(camView.getEye()),
                    new Point3d(camView.getTarget()), camView.getUp());
            transform.invert();
            view.glCamera.setTransform(transform);
        }
    }

    public class ViewInfo implements ViewController {

        Canvas3D canvas;
        TransformGroup glCamera;
        int camNum = 0;
        
        Camera<Vector3d> camera;
        BranchGroup viewBranch;
        View view;
        
        public ViewInfo(Canvas3D canvas) {
            this.canvas = canvas;
        }

        public void init() {
            if(view != null) {
                view.removeCanvas3D(canvas);
            }
            view = new View();
            view.addCanvas3D(canvas);
            view.setPhysicalBody(new PhysicalBody());
            view.setPhysicalEnvironment(new PhysicalEnvironment());
            view.setBackClipDistance(1000);
            view.setSceneAntialiasingEnable(true);
            //assert canvas.getSceneAntialiasingAvailable();

            viewBranch = new BranchGroup();
            glCamera = new TransformGroup();
            glCamera.setCapability(TransformGroup.ALLOW_TRANSFORM_WRITE);
            ViewPlatform viewPlatform = new ViewPlatform();
            glCamera.addChild(viewPlatform);
            viewBranch.addChild(glCamera);

            view.attachViewPlatform(viewPlatform);

            camera = buildCamera(camNum, helper, track);
        }

        Camera buildCamera(int camNum, TrackHelperJ3d helper, Track track) {
            var cam = CameraFactory.buildCamera(camList.get(camNum), helper);
            cam.init(track);
            return cam;
        }

        public int getCamNum() {
            return camNum;
        }
        
        public void setCamNum(int camNumNew) {
            int n = camList.size();
            camNum = ((camNumNew % n) + n) % n;
            if (track != null) {
                camera = buildCamera(camNum, helper, track);
            }
        }
        
        @Override
        public void nextCam() {
            setCamNum(getCamNum() + 1);
        }
        
        @Override
        public void prevCam() {
            setCamNum(getCamNum() - 1);
        }
    }
    
}
