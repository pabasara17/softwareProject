package com.example.ecommercecheck1;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;

public class AdminCategoryActivity extends AppCompatActivity {

    private ImageView Gem,Jwel;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_admin_category);


        Gem = (ImageView) findViewById(R.id.categorygem1);
        Jwel = (ImageView) findViewById(R.id.categoryjwel1);






        Gem.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent i = new Intent(AdminCategoryActivity.this,AdminAddNewProductActivity.class);
                getIntent().putExtra("category","Gem");
                startActivity(i);
            }
        });


        Jwel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent i = new Intent(AdminCategoryActivity.this,AdminAddNewProductActivity.class);
                getIntent().putExtra("category","Jwel");
                startActivity(i);
            }
        });


    }
}
