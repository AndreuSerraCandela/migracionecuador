table 76411 "FlagsInRepeater Bitmaps"
{

    fields
    {
        field(1; Status; Option)
        {
            OptionCaption = ' ,Sent by salesperson,Approved,Programmed,Voided,Rejected,Done';
            OptionMembers = " ","Enviada por promotor",Aprobada,Programada,Cancelada,Rechazada,Realizada;
        }
        field(2; Bitmap; BLOB)
        {
            SubType = Bitmap;
        }
    }

    keys
    {
        key(Key1; Status)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

