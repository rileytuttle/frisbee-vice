include <BOSL2/std.scad>
include <common-dims.scad>
use <screw-peg.scad>
use <logo.scad>
use <linkage.scad>
include <rosetta-stone/std.scad>

$fn=30;

module main_jaw(anchor=CENTER, spin=0, orient=UP, static=false, spare_linkage=false, machine_screw=true, jaw_strength_screw=false, material, logo=true, logo_text=true, overall_thickness=7, name_info, quahog_logo=false) {

    anchor_list = [
        if(!static) named_anchor("neck-collar", main_jaw_neck_collar_center_displacement),
        named_anchor("screw-peg-center", main_peg_displacement),
        if(static) named_anchor("screw-peg-2-center", main_jaw_screw_peg_2_displacement), 
    ];
    tag_scope()
    attachable(size=[0, 0, overall_thickness], spin=spin, anchor=anchor, orient=orient, anchors=anchor_list) {
        diff() {
            // right side main
            cuboid([right_side_main_body_len, main_jaw_body_height, overall_thickness], anchor=BACK+LEFT, rounding=5, edges=BACK+RIGHT) {
                {
                    // add the carriage joint at a certain distance
                    position(FRONT+RIGHT)
                    fwd(carriage_joint_offset+joint_outer_diam/2)
                    cyl(d=joint_outer_diam, l=overall_thickness, anchor=RIGHT) {
                        cube([joint_outer_diam, carriage_joint_offset+joint_outer_diam/2, overall_thickness], anchor=FRONT){
                            tag("remove")
                            position(FRONT)
                            cube([joint_outer_diam+0.1, linkage_arm_width/2, joint_thickness+0.1], anchor=CENTER);
                        }
                        force_tag("remove")
                        machine_screw_pocket(overall_thickness=overall_thickness);
                    }
                    // version string
                    if (logo_text)
                    position(FRONT+LEFT+TOP)
                    tag("remove")
                    back(5)
                    right(1)
                    text3d(version_string, h=0.5, size=4, anchor=TOP+LEFT);
                }
                // joint outer meat
                position(LEFT+FRONT)
                left(7)
                cyl(d=joint_outer_diam, l=overall_thickness) {
                    force_tag("remove")
                    machine_screw_pocket(overall_thickness=overall_thickness);
                }
                // left side main
                position(LEFT)
                cuboid([30, main_jaw_body_height, overall_thickness], anchor=RIGHT, rounding=5, edges=LEFT+BACK) {
                // remove throat circle
                    move_fwd_dist=13;
                    tag("remove")
                    position(RIGHT+BACK)
                    left(18)
                    fwd(move_fwd_dist)
                    cyl(d=7, l=overall_thickness+1)
                        // remove throat middle
                        xrot(-90)
                        cuboid([7, overall_thickness+1, 20-move_fwd_dist], anchor=TOP, chamfer=-2.5, edges=BOTTOM+RIGHT);
                    // add more throat
                    position(LEFT+FRONT)
                    cuboid([30 - 18 - 7/2, 9, overall_thickness], anchor=BACK+LEFT, rounding=4, edges=FRONT+RIGHT);

                    // material string
                    if (material != undef)
                    tag("remove")
                    position(LEFT+BACK+TOP) {
                        fwd(5)
                        right(0.5)
                        text3d(material, h=0.5, size=6, anchor=BACK+RIGHT+TOP, spin=90);
                    }
                    // add screw for jaw strength
                    if (jaw_strength_screw)
                    {
                        position(LEFT+BACK)
                        tag("remove")
                        fwd(5)
                        right(1.5)
                        screw_hole("M3x0.5", head="socket", thread=true, l=13, anchor=TOP, orient=LEFT)
                        position(TOP)
                        cyl(d=5.5, l=3, anchor=BOTTOM);
                    }
                }

                // logo
                if (logo)
                force_tag("remove")
                position(LEFT+BACK+TOP)
                left(6.75)
                fwd(8.25)
                cyl(d=discvice_logo_diam, l=0.5)
                position(BOTTOM)
                d_negative(d=discvice_logo_diam, l=overall_thickness, anchor=TOP) {
                    if (quahog_logo)
                    {
                        right(6)
                        fwd(5)
                        slot(d=2, spread=5, h=overall_thickness+1, spin=-30, round_radius=0);
                        up(0.3) right(17.5) fwd(3.5) position(TOP) text3d("hogs", size=7, h=0.5, anchor=TOP);
                    }
                }
                // logo text
                if (logo_text)
                tag("remove")
                position(TOP+LEFT)
                right(0.8)
                back(1.75)
                up(0.01)
                text3d(static ? "iscv" : "iscvice", h=0.5, size=7, anchor=TOP+LEFT);
                

                // // clip hole
                // position(BACK+RIGHT)
                // left(18/2)
                // cyl(d=18, l=overall_thickness)
                //     tag("remove")
                //     cyl(d=12, l=overall_thickness+0.1, rounding=-3, teardrop=true);
                
                // extra_linkage_cutouts
                if (spare_linkage) {
                    position(BOTTOM)
                    left(1.5)
                    fwd(1.5)
                    rotate(45)
                    {
                        // the pocket
                        // down(0.1) 
                        tag("remove")
                        linkage_arm(linkage_arm_length2, linkage_arm_hole_diam-0.5, linkage_arm_joint_diam+0.3, linkage_arm_thickness+0.4, linkage_arm_width+0.3, anchor=BOTTOM);
                        // the linkage arm
                        tag("keep")
                        // up(0.1)
                        linkage_arm(linkage_arm_length2, linkage_arm_hole_diam, linkage_arm_joint_diam, linkage_arm_thickness, linkage_arm_width, anchor=BOTTOM) {
                            position(BOTTOM)
                            cyl(d=2.5, l=overall_thickness/2, anchor=BOTTOM);
                        }
                    }
                }
                if (name_info != undef)
                {
                    force_tag("remove")
                    up(0.01)
                    translate(name_info[1])
                    #position(TOP) text3d(name_info[0], h=0.5, size=name_info[2], spin=name_info[3], anchor=TOP);
                }
            }
        }
        children();
    }
}

// bottom_half()
main_jaw(static=true, spare_linkage=true);
