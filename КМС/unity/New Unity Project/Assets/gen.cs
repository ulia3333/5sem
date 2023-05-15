using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class gen : MonoBehaviour
{
    public MeshRenderer rend;
    public float minX;
    public float maxX;
    public float minZ;
    public float maxZ;
    private float nX;
    private float nY;
    private float nZ;
    public GameObject pref;
    void Start()
    {
        rend = GameObject.FindWithTag("Cube").GetComponent<MeshRenderer>();        
        nY = gameObject.transform.position.y + 5;
    }
    void Update()
    {
        nX = Random.Range(minX, maxX);
        nZ = Random.Range(minZ, maxZ);

        if (Input.GetKeyDown(KeyCode.Space))
        {
            Vector3 position = new Vector3(nX, nY, nZ); 
            GameObject sphere = Instantiate(pref, position, Quaternion.identity);
            sphere.AddComponent<Rigidbody>();
        }
    }
}
