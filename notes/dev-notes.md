# On Demand Minecraft Server
Using a Python Flask application and AWS, this repository launches an AWS EC2 Instance to host a Minecraft server upon request from users through the web application. The server will automatically shut down after the server has crashed or is empty for 15 minutes. This makes server hosting for small communities very inexpensive. For up to 20 players you can expect $0.02 per hour the server runs. The largest benefit of this system is that the server bill diminishes if your community decides to take a break from the game, and will be ready to pick back up when you want to play again. No subscriptions are required.

Note that this configuration will likely require familiarity with programming, SSH, and the command line.


# AWS Setup
This step will properly configure your AWS account and `configuration.py` file so that an instance can be created via the `createInstance.py` script.

<!-- TODO: Automate loading of AWS credentials -->
 1. Create or access an **AWS Account**. Under the **User Dropdown** in the    **Toolbar**, select **Security Credentials**, then **Access Keys**, and finally **Create New Access Key**. Download this file, open it, and copy the values of **AWSAccessKeyId** and **AWSSecretKey** to **ACCESS_KEY** and **SECRET_KEY** in the **`configuration.py`** file in the root directory of the repository.
	
	<code>ACCESS_KEY = 'YourAWSAccessKeyIdHere'
	SECRET_KEY  =  'YourAWSSecretKeyHere'</code> 

<!-- TODO: Automate via CloudFormation Template (Ansible) -->
 3. Navigate to the **EC2 Dashboard** under the **Services Dropdown** and select **Security Groups** in the sidebar. Select **Create Security Group**, input **minecraft** for the **Security group name**. Create **Inbound Rules** for the following:
	 - Type: **SSH** Protocol: **TCP** Port Range: **22** Source: **Anywhere**
	 - Type: **Custom TCP Rule** Protocol: **TCP** Port Range: **25565** Source: **Anywhere**
	 - Type: **Custom UDP Rule** Protocol: **UDP** Port Range: **25565** Source: **Anywhere**
	 
	 In **configuration.py** in the root directory, set **ec2_secgroups** to the name of the security group.
	 
	 <code>ec2_secgroups =  ['YourGroupNameHere']</code>

<!-- TODO: Automate via Ansible Playbook & feed into CFN template -->
3. Under the **EC2 Dashboard** navigate to **Key Pairs** in the sidebar. Select **Create Key Pair**, provide a name and create. Move the file that is downloaded into the root directory of the project. In **configuration.py** in the root directory, set ** ec2_keypair** to the name entered, and **SSH_KEY_FILE_NAME** to the name.pem of the file downloaded.

	THIS MIGHT BE SUBJECT TO CHANGE
		<code>ec2_keypair =  'YourKeyPairName'
		SSH_KEY_FILE_PATH  =  './YourKeyFileName.pem'</code>

<!-- TODO: Hard code the region for now? Can be passed in via Ansible task -->
4. This step is concerned with creating the AWS instance. View [https://docs.aws.amazon.com/general/latest/gr/rande.html](https://docs.aws.amazon.com/general/latest/gr/rande.html) (Or google AWS Regions), and copy the  **Region** column for the **Region Name** of where you wish to host your server. In **configuration.py** of the root directory, set the **ec2_region** variable to the copied value.

	<code>ec2_region =  "Your-Region-Here"</code>

<!-- TODO: Automate via Ansible Playbook & feed into CFN template (start with t2.micro) -->
5. Navigate to [https://aws.amazon.com/ec2/instance-types/](https://aws.amazon.com/ec2/instance-types/) and select one of the T3 types (with the memory and CPU you desire, I recommend 10 players/GB). Copy the value in the **Model** column. I've configured mine to use **t3.small**. In **configuration.py** of the root directory, set the **ec2_instancetype** variable to the copied value.

	<code>ec2_instancetype =  't3.yourSizeHere'</code>

<!-- TODO: Automate via Ansible Playbook & feed into CFN template (start with t2.micro) -->
6. Then we must select an image for the instance to boot. Navigate to [https://cloud-images.ubuntu.com/locator/ec2/](https://cloud-images.ubuntu.com/locator/ec2/), in the filter at the bottom of the screen, select your region of choice under **Zone**, pick any LTS (Latest Stable) under **Version**, under **Arch** select **amd64**, and **hvm:ebs** under **Instance Type**. Select one of the images available and copy the **AMI-ID**. In **configuration.py** of the root directory, set the **ec2_amis** variable to the copied value.

	<code>ec2_amis =  ['ami-YourImageIdHere']</code>

7. At this point you should have the necessary configuration to create a new instance through the **createInstance.py** script in the **root** folder. Open a command line in the utilityScripts directory of the project, and execute:

<!-- TODO: Dockerize the Sh!t out of this -->
	<code>pip install -r requirements.txt</code>
	
	After successful installation of dependencies execute:

<!-- TODO: Ansible task (createEC2) -->
	<code>python utilityScripts/createInstance.py</code>

<!-- TODO: Grab value of EC2 instance from ec2_facts -->
	Copy the **Instance ID** that is output into the terminal. In **configuration.py** of the root directory, set the **INSTANCE_ID** variable to the copied value.

	<code>INSTANCE_ID  =  'i-yourInstanceIdHere'</code>
