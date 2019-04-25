#include "ros/ros.h"
#include "std_msgs/String.h"


int main(int argc, char **argv)
{
  ros::init(argc, argv, "talker");
  ros::NodeHandle n;
  ros::Publisher pub = n.advertise<std_msgs::String>("chatter", 1000);
  ros::Rate loop_rate(10);

  while (ros::ok()) {
    //pub.publish("Hello there!");
    ros::spinOnce();
    loop_rate.sleep();
  }

  return 0;
}
