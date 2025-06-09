pageextension 50075 pageextension50075 extends Teams
{
    layout
    {
        addafter(Name)
        {
            field("Campaña"; rec.Campaña)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}

