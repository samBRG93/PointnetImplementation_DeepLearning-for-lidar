import os
import sys
import numpy as np
import h5py

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.join(BASE_DIR, 'Desktop', 'Radvance_project', 'tensorflow_code'))


# Download dataset for point cloud classification
DATA_DIR = os.path.join(BASE_DIR, 'data')
if not os.path.exists(DATA_DIR):
    os.mkdir(DATA_DIR)
if not os.path.exists(os.path.join(DATA_DIR, 'modelnet40_ply_hdf5_2048')):
    www = 'https://shapenet.cs.stanford.edu/media/modelnet40_ply_hdf5_2048.zip'
    zipfile = os.path.basename(www)
    os.system('wget %s; unzip %s' % (www, zipfile))
    os.system('mv %s %s' % (zipfile[:-4], DATA_DIR))
    os.system('rm %s' % (zipfile))


def shuffle_data(data, labels):
    """ Shuffle data and labels.
        Input:
          data: B,N,... numpy array
          label: B,... numpy array
        Return:
          shuffled data, label and shuffle indices
    """
    idx = np.arange(len(labels))
    np.random.shuffle(idx)
    return data[idx, ...], labels[idx], idx


def get_y_rotation_matrix(angle):
    """Crea una matrice di rotazione attorno all'asse Y."""
    cosval = np.cos(angle)
    sinval = np.sin(angle)
    return np.array([
        [cosval, 0, sinval],
        [0, 1, 0],
        [-sinval, 0, cosval]
    ], dtype=np.float32)


def rotate_point_cloud(batch_data):
    """
    Ruota casualmente ogni nuvola di punti del batch attorno all'asse Y.
    Input:
        batch_data: array di shape (B, N, 3)
    Output:
        rotated_data: array di shape (B, N, 3)
    """
    assert batch_data.shape[-1] == 3, "Ultima dimensione deve essere 3 (coordinate x,y,z)"
    rotated_data = np.zeros_like(batch_data, dtype=np.float32)

    for k in range(batch_data.shape[0]):
        angle = np.random.uniform(0, 2 * np.pi)
        R = get_y_rotation_matrix(angle)
        rotated_data[k] = batch_data[k] @ R  # più leggibile di np.dot
    return rotated_data


def rotate_point_cloud_by_angle(batch_data, rotation_angle):
    """
    Ruota ogni nuvola di punti del batch di un angolo specificato attorno all'asse Y.
    Input:
        batch_data: array di shape (B, N, 3)
        rotation_angle: float, angolo in radianti
    Output:
        rotated_data: array di shape (B, N, 3)
    """
    assert batch_data.shape[-1] == 3, "Ultima dimensione deve essere 3 (coordinate x,y,z)"
    R = get_y_rotation_matrix(rotation_angle)
    rotated_data = np.matmul(batch_data, R)  # broadcasting: ogni punto ruotato con R
    return rotated_data


def jitter_point_cloud(batch_data, sigma=0.01, clip=0.05):
    """ Randomly jitter points. jittering is per point.
        Input:
          BxNx3 array, original batch of point clouds
        Return:
          BxNx3 array, jittered batch of point clouds
    """
    B, N, C = batch_data.shape
    assert (clip > 0)
    jittered_data = np.clip(sigma * np.random.randn(B, N, C), -1 * clip, clip)
    jittered_data += batch_data
    return jittered_data


def load_h5(h5_filename):
    with h5py.File(h5_filename, 'r') as f:
        data = f['data'][:]
        label = f['label'][:]
    return data, label


def load_data_file(filename):
    print("inside loadDataFile: ", filename)
    return load_h5(filename)


def load_h5_data_label_seg(h5_filename):
    f = h5py.File(h5_filename)
    data = f['data'][:]
    label = f['label'][:]
    seg = f['pid'][:]
    return data, label, seg


def load_data_file_with_seg(filename):
    return load_h5_data_label_seg(filename)
