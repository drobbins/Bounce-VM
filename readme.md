# Getting Started

1. Download and install VirtualBox and Vagrant (if you don't already have them)
    * [VirtualBox](https://www.virtualbox.org/)
    * [Vagrant](http://www.vagrantup.com/downloads.html)
2. Clone this repo: ``git clone https://github.com/drobbins/Bounce-VM.git``
3. ``cd Bounce-VM``
4. ``vagrant up``

After everything is finished, Bounce should be running on ``http://localhost:27080``. You can ``vagrant ssh`` to access the running VM.

## Tips

* To suspend or halt the VM, use ``vagrant suspend`` or ``vagrant halt`` respectively. ``vagrant up`` to start it again.
* If Bounce does not seem to be running, try running ``vagrant provision``.
