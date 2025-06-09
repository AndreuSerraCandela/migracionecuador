table 50115 "Usuarios Ponchador HMW"
{
    //ExternalName = 'User'; // <-- Comentar si no es tabla externa
    //ExternalSchema = 'dbo'; // <-- Comentar si no es tabla externa
    //TableType = ExternalSQL; // <-- Comentar si no es tabla externa

    fields
    {
        field(1; IdUser; Integer)
        {
            // ExternalName = 'IdUser';
            // ExternalType = 'Integer DataClassification=ToBeClassified';
        }
        field(2; IdentificationNumber; Code[20])
        {
            // ExternalName = 'IdentificationNumber';
            // ExternalType = 'String DataClassification=ToBeClassified';
        }
        field(3; Name; Text[250])
        {
            // ExternalName = 'Name';
            // ExternalType = 'String DataClassification=ToBeClassified';
        }
        field(4; Gender; Boolean)
        {
            //Enabled = false; // No existe en AL
        }
        field(5; Title; Text[100])
        {
            // ExternalName = 'Title';
            // ExternalType = 'String DataClassification=ToBeClassified';
        }
        field(6; Birthday; DateTime)
        {
            // ExternalName = 'Birthday';
            // ExternalType = 'Datetime DataClassification=ToBeClassified';
        }
        field(7; PhoneNumber; Text[50])
        {
            // ExternalName = 'PhoneNumber';
            // ExternalType = 'String DataClassification=ToBeClassified';
        }
        field(8; MobileNumber; Text[50])
        {
            // ExternalName = 'MobileNumber';
            // ExternalType = 'String DataClassification=ToBeClassified';
        }
        field(9; Address; Text[250])
        {
            // ExternalName = 'Address';
            // ExternalType = 'String DataClassification=ToBeClassified';
        }
        field(10; ExternalReference; Text[50])
        {
            // ExternalName = 'ExternalReference';
            // ExternalType = 'String DataClassification=ToBeClassified';
        }
        field(11; IdDepartment; Integer)
        {
            // ExternalName = 'IdDepartment';
            // ExternalType = 'Integer DataClassification=ToBeClassified';
        }
        field(12; Position; Text[150])
        {
            // ExternalName = 'Position';
            // ExternalType = 'String DataClassification=ToBeClassified';
        }
        field(13; Active; Integer)
        {
            // ExternalName = 'Active';
            // ExternalType = 'integer InitValue=1';
        }
        field(14; Picture; BLOB)
        {
            //Enabled = false;
            // ExternalName = 'Picture';
        }
        field(15; PictureOrientation; Integer)
        {
            //Enabled = false;
            // ExternalName = 'PictureOrientation';
        }
        field(16; Privilege; Integer)
        {
            // ExternalName = 'Privilege';
            // ExternalType = 'Integer DataClassification=ToBeClassified';
        }
        field(17; HourSalary; Decimal)
        {
            // ExternalName = 'HourSalary';
            // ExternalType = 'Decimal DataClassification=ToBeClassified';
        }
        field(18; Password; Text[50])
        {
            // ExternalName = 'Password';
            // ExternalType = 'String DataClassification=ToBeClassified';
        }
        field(19; PreferredIdLanguage; Integer)
        {
            // ExternalName = 'PreferredIdLanguage';
            // ExternalType = 'integer';
        }
        field(20; Email; Text[200])
        {
            // ExternalName = 'Email';
            // ExternalType = 'String DataClassification=ToBeClassified';
        }
        field(21; Comment; Text[200])
        {
            // ExternalName = 'Comment';
            // ExternalType = 'String DataClassification=ToBeClassified';
        }
        field(22; ProximityCard; Code[50])
        {
            // ExternalName = 'ProximityCard';
            // ExternalType = 'String DataClassification=ToBeClassified';
        }
        field(23; LastRecord; DateTime)
        {
            // ExternalName = 'LastRecord';
            // ExternalType = 'Datetime DataClassification=ToBeClassified';
        }
        field(24; LastLogin; DateTime)
        {
            // ExternalName = 'LastLogin';
            // ExternalType = 'Datetime DataClassification=ToBeClassified';
        }
        field(25; CreatedBy; Integer)
        {
            // ExternalName = 'CreatedBy';
            // ExternalType = 'Integer DataClassification=ToBeClassified';
        }
        field(26; CreatedDatetime; DateTime)
        {
            // ExternalName = 'CreatedDatetime';
            // ExternalType = 'Datetime DataClassification=ToBeClassified';
        }
        field(27; ModifiedBy; Integer)
        {
            // ExternalName = 'ModifiedBy';
            // ExternalType = 'Integer DataClassification=ToBeClassified';
        }
        field(28; ModifiedDatetime; DateTime)
        {
            // ExternalName = 'ModifiedDatetime';
            // ExternalType = 'Datetime DataClassification=ToBeClassified';
        }
        field(29; AdministratorType; Integer)
        {
            // ExternalName = 'AdministratorType';
            // ExternalType = 'Integer DataClassification=ToBeClassified';
        }
        field(30; IdProfile; Integer)
        {
            // ExternalName = 'IdProfile';
            // ExternalType = 'Integer DataClassification=ToBeClassified';
        }
        field(31; DevPassword; Text[255])
        {
            // ExternalName = 'DevPassword';
            // ExternalType = 'String DataClassification=ToBeClassified';
        }
        field(32; UseShift; Integer)
        {
            // ExternalName = 'UseShift';
        }
        field(33; SendSMS; Integer)
        {
            // ExternalName = 'SendSMS';
            // ExternalType = 'Integer DataClassification=ToBeClassified';
        }
        field(34; SMSPhone; Text[50])
        {
            // ExternalName = 'SMSPhone';
            // ExternalType = 'String DataClassification=ToBeClassified';
        }
        field(35; TemplateCode; Integer)
        {
            // ExternalName = 'TemplateCode';
            // ExternalType = 'Integer DataClassification=ToBeClassified';
        }
        field(36; ApplyExceptionPermition; Integer)
        {
            //Enabled = false;
            // ExternalName = 'ApplyExceptionPermition';
        }
        field(37; ExceptionPermitionBegin; DateTime)
        {
            //Enabled = false;
            // ExternalName = 'ExceptionPermitionBegin';
        }
        field(38; ExceptionPermitionEnd; DateTime)
        {
            //Enabled = false;
            // ExternalName = 'ExceptionPermitionEnd';
        }
        field(39; CodigoBC; Integer)
        {
            // ExternalName = 'CodigoBC';
        }
    }

    keys
    {
        key(Key1; IdUser)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}