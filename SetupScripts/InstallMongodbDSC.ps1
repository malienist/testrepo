# DSC Script to install Mongodb onto Base Virtual Machine

Configuration InstallMongoDB
{
    Node localhost
    {
        Package InstallMongoDB
        {
            # todo: check where Mongodb actually normally installs to
            # todo: Check if there is a way to accept default installs for MongoDB
            Ensure = 'Present'
            Name = "mongodb.msi"
            Path = "C:\Program Files"
            ProductId = ""
        }
    }

}