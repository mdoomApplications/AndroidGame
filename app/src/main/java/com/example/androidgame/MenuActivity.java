


<![CDATA[package com.example.androidgame;

import android.os.Bundle;
import android.widget.Button;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

public class MenuActivity extends AppCompatActivity {

    private Button learnReadButton;
    private Button learnCountButton;
    private TextView playerNameTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(Bundle savedInstanceState);
        setContentView(R.layout.activity_menu);

        playerNameTextView = findViewById(R.id.playerNameTextView);

        learnReadButton = findViewById(R.id.learnReadButton);
        learnCountButton = findViewById(R.id.learnCountButton);

        String playerName = getIntent().getStringExtra("playerName");
        playerNameTextView.setText("Hráč: " + playerName);

    }
}
]]>


